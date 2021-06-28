shader_type canvas_item;

uniform float width = 64;
uniform float height = 64;
uniform float scale = 1;
uniform bool skew_enabled = false;
uniform vec2 mouse_position = vec2(0, 0);


void vertex() {
	// scale
	float x = VERTEX.x;
	float y = VERTEX.y;
	
	float half_width = width / 2.0;
	float half_height = height / 2.0;
	
	if (x <= 0.0) {
		x = -half_width * scale;
	} else {
		x = half_width * scale;
	}
	
	if (y <= 0.0) {
		y = -half_height * scale;
	} else {
		y = half_height * scale;
	}
	
	if (skew_enabled) {
		/*float sx = mouse_position.x * ((skew_amount + skew_amount) / width);
		float sy = mouse_position.y * ((skew_amount + skew_amount) / height);
		x += sx * sign(x) + sy * sign(x);
		y += sy * sign(y) + sx * sign(y);*/
		
		float sx = mouse_position.x / x; // 1 - mouse is close to edge, 0 - mouse in center, -1 - mouse on other edge
		float sy = mouse_position.y / y;
		float z = 1.0 + sx / 10.0 + sy / 10.0; // z can go from 0.9 to 1.1
		// float fake_xz = mouse_position.x / half_width + 3.0;
		// float fake_yz = mouse_position.y / half_height * sign(y) + 3.0;
		x = x / z;
		y = y / z;
	}
	
	VERTEX = vec2(x, y);
}
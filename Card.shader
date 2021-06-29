shader_type canvas_item;

uniform float width = 64;
uniform float height = 64;
uniform float scale = 1;
uniform bool skew_enabled = false;
uniform vec2 mouse_position = vec2(0, 0);
uniform vec4 shadow_color : hint_color;


void vertex() {
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
	
	VERTEX = vec2(x, y);
}

void fragment() {
	vec2 uv = UV;

	// map skew to [-0.5, 0.5]
	float skew_x = mouse_position.x / width;
	float skew_y = mouse_position.y / height;
	
	// map to [-0.5, 0.5]
	uv.x = (uv.x - 0.5);
	uv.y = (uv.y - 0.5);
	
	float sx = 1.0 - (uv.x * skew_x);
	float sy = 1.0 - (uv.y * skew_y);
	
	float z = 1.0 + (sx * sy) / 2.0;
	uv.x = uv.x / z;
	uv.y = uv.y / z;
	
	// scale a bit down a reset mapping from [-0.5, 0.5] to [0, 1]
	uv.x = uv.x / 0.45 + 0.5;
	uv.y = uv.y / 0.45 + 0.5;
	//uv.x = uv.x + 0.5;
	// uv.y = uv.y + 0.5;
	COLOR = texture(TEXTURE, uv);
	
	if (uv.x < 0.0 || uv.x > 1.0) {
		COLOR.a = 0.0;
	} else if (uv.y < 0.0 || uv.y > 1.0) {
		COLOR.a = 0.0;
	} else {
		// brightness
		float brightness = 1.0 - mouse_position.y / (height / 2.0) * 0.2;
		COLOR.rgb = texture(TEXTURE, uv, 1.0).rgb * brightness;
		
		COLOR.a = texture(TEXTURE, uv, 1.0).a;
	}
}
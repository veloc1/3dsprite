extends TextureRect

var mouse_on_card = false
var mouse_position_for_skew = Vector2(0, 0)

func _ready():
	material.set_shader_param("width", get_rect().size.x)
	material.set_shader_param("height", get_rect().size.y)
	#$Shadow.hide()

func _process(delta):
	if not mouse_on_card:
		mouse_position_for_skew = mouse_position_for_skew.linear_interpolate(Vector2(get_rect().size.x / 2, get_rect().size.y / 2), 5 * delta )

	material.set_shader_param("mouse_position", mouse_position_for_skew)
	#$Shadow.material.set_shader_param("mouse_position", mouse_position_for_skew)

func _input(event):
	if event is InputEventMouseMotion:
		var actual_rect = get_rect()
		var local_pos = event.position - get_rect().position
		if actual_rect.has_point(event.position):
			mouse_on_card = true
			material.set_shader_param("skew_enabled", true)
			#$Shadow.show()

			mouse_position_for_skew = local_pos
		else:
			# if on previous motion mouse was on card and on this frame mouse is moved out - reset flag
			if mouse_on_card:
				mouse_on_card = false
				material.set_shader_param("skew_enabled", false)
				#$Shadow.hide()

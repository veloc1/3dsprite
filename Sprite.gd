extends Sprite

var mouse_on_card = false
var mouse_position_for_skew = Vector2(0, 0)

func _ready():
	material.set_shader_param("width", get_texture().get_width())
	material.set_shader_param("height", get_texture().get_height())

func _process(delta):
	if not mouse_on_card:
		# lerp position to (0, 0) if mouse outside bounds
		mouse_position_for_skew = mouse_position_for_skew.linear_interpolate(Vector2(0, 0), 5 * delta )

	material.set_shader_param("mouse_position", mouse_position_for_skew)

func _input(event):
	if event is InputEventMouseMotion:
		var actual_rect = get_rect()
		if actual_rect.has_point(to_local(event.position)):
			mouse_on_card = true

			mouse_position_for_skew = to_local(event.position)
		else:
			# if on previous motion mouse was on card and on this frame mouse is moved out - reset flag
			if mouse_on_card:
				mouse_on_card = false

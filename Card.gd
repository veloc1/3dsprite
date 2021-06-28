extends Sprite

# firstly, check if mouse in card bounds. look at _input func
# set target scale and lerp to it in process every frame

const NORMAL_SCALE = 1
const CARD_SCALE = 1.5

var mouse_on_card = false
var target_scale = 1
var actual_scale = 1
var mouse_position_for_skew = Vector2(0, 0)

func _ready():
	material.set_shader_param("width", get_texture().get_width())
	material.set_shader_param("height", get_texture().get_height())
	$Shadow.hide()

func _process(delta):
	actual_scale = lerp(actual_scale, target_scale, 5 * delta)
	if not mouse_on_card:
		mouse_position_for_skew = mouse_position_for_skew.linear_interpolate(Vector2(0, 0), 5 * delta )

	material.set_shader_param("scale", actual_scale)
	material.set_shader_param("mouse_position", mouse_position_for_skew)
	$Shadow.material.set_shader_param("mouse_position", mouse_position_for_skew)

func _input(event):
	if event is InputEventMouseMotion:
		var actual_rect = null
		if mouse_on_card:
			actual_rect = get_rect().grow((texture.get_width() * CARD_SCALE) - texture.get_width())
		else:
			actual_rect = get_rect()
		if actual_rect.has_point(to_local(event.position)):
			mouse_on_card = true
			material.set_shader_param("skew_enabled", true)
			$Shadow.show()

			target_scale = CARD_SCALE

			mouse_position_for_skew = to_local(event.position)
		else:
			# if on previous motion mouse was on card and on this frame mouse is moved out - reset flag
			if mouse_on_card:
				mouse_on_card = false
				material.set_shader_param("skew_enabled", false)
				$Shadow.hide()

				target_scale = NORMAL_SCALE


extends Container
class_name CircleContainer

@export var radius: int = 64
@export var rotate_delay: float = 0.1

var current_idx: int = 0

func _ready() -> void:
	reposition_buttons()
	%Background.position -= %Background.size / 2

# Debug code: comment out when not using!
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump", false):
		%Buttons.add_child(Button.new())
	if event.is_action_pressed("ui_left", false):
		rotate(-1)
	if event.is_action_pressed("ui_right", false):
		rotate(1)
	reposition_buttons()

func rotate(shift: int) -> void:
	current_idx = (current_idx + shift) % %Buttons.get_child_count()

func reposition_buttons() -> void:
	var item_size: int = %Buttons.get_child_count()
	var radius_vector: Vector2 = Vector2(0, -radius)
	for idx in range(item_size):
		var button: Button = %Buttons.get_child(idx)
		var angle: float = ((idx + current_idx) % item_size) * (2 * PI) / item_size
		
		var tween: Tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(button, "position", radius_vector.rotated(angle), rotate_delay)

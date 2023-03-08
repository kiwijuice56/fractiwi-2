extends Node
class_name CrouchState

@export var player: FpsPlayer 
@export var cam: Camera3D

@export var crouch_speed := 16
@export var fov_multiplier := 1.05
@export var cam_offset := -1.0
@onready var normal_speed: float = player.walk_speed
@onready var normal_fov: float = cam.fov

# Called every physics tick. 'delta' is constant
func _physics_process(delta: float) -> void:
	if can_sprint():
		player.walk_speed = crouch_speed
		cam.set_fov(lerp(cam.fov, normal_fov * fov_multiplier, delta * 8))
		cam.position.y = lerp(cam.position.y, cam_offset, delta * 8)
	else:
		player.walk_speed = normal_speed
		cam.set_fov(lerp(cam.fov, normal_fov, delta * 8))
		cam.position.y = lerp(cam.position.y, 0.0, delta * 8)

func can_sprint() -> bool:
	return player.is_on_floor() and Input.is_action_pressed(&"crouch")

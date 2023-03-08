extends CharacterBody3D
class_name FpsPlayer
# https://github.com/Whimfoome/godot-FirstPersonStarter

@export var gravity_multiplier := 3.0
@export var walk_speed := 10.0
@export var jump_speed := 12.0
@export var acceleration := 8.0
@export var deceleration := 10.0
@export_range(0.0, 1.0, 0.05) var air_control := 0.3
@export var jump_height := 10.0

var speed := walk_speed
var direction := Vector3()
var input_axis := Vector2()
var jump_buffered := false

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
@onready var gravity: float = (ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_multiplier)

func _ready() -> void:
	%JumpBufferTimer.timeout.connect(_reset_jump_buffer)

func _reset_jump_buffer() -> void:
	jump_buffered = false

# Called every physics tick. 'delta' is constant
func _physics_process(delta: float) -> void:
	input_axis = Input.get_vector(&"move_back", &"move_forward", &"move_left", &"move_right")
	
	direction_input()
	if Input.is_action_pressed(&"jump") or jump_buffered:
		if is_on_floor():
			velocity.y = jump_height
			speed = jump_speed / 4.0 if input_axis.x <= 0.25 else jump_speed
			jump_buffered = false
		elif not jump_buffered:
			jump_buffered = true
			%JumpBufferTimer.start()
	velocity.y -= gravity * delta
	
	accelerate(delta)
	
	move_and_slide()

func direction_input() -> void:
	direction = Vector3()
	var aim: Basis = get_global_transform().basis
	direction = aim.z * -input_axis.x + aim.x * input_axis.y

func accelerate(delta: float) -> void:
	speed = lerp(speed, walk_speed, delta * 4)
	%SpeedLabel.text = str(speed)
	# Using only the horizontal velocity, interpolate towards the input.
	var temp_vel := velocity
	temp_vel.y = 0
	
	var temp_accel: float
	var target: Vector3 = direction * speed
	
	if direction.dot(temp_vel) > 0:
		temp_accel = acceleration
	else:
		temp_accel = deceleration
	
	if not is_on_floor():
		temp_accel *= air_control
	
	temp_vel = temp_vel.lerp(target, temp_accel * delta)
	
	velocity.x = temp_vel.x
	velocity.z = temp_vel.z

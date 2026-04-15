extends CharacterBody2D

@onready var camera: Camera2D = $camera2d

const JUMP_VELOCITY = -400.0
const SPEED = 300.0

var isDoubleJump = true

func _physics_process(delta: float) -> void:
	player_movement(delta)
	camera_movement()
	move_and_slide()

# Control the player's movement
func player_movement(delta: float):
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump and double jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		isDoubleJump = true
	elif Input.is_action_just_pressed("jump") and !is_on_floor() and isDoubleJump:
		velocity.y = JUMP_VELOCITY
		isDoubleJump = false

	# Handle horizontal movement
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

# Control the vertical movement of the camera
func camera_movement():
	if !camera:
		return
		
	if Input.is_action_pressed("ui_down"):
		camera.drag_vertical_offset = 1
	elif Input.is_action_pressed("ui_up"):
		camera.drag_vertical_offset = -1
	else:
		camera.drag_vertical_offset = 0

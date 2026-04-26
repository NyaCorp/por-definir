extends CharacterBody2D
class_name Player

@onready var bullet_position: Marker2D = $BulletPosition
@onready var bullet_timer: Timer = $BulletTimer
@onready var shoot_sound: AudioStreamPlayer = $ShootSound

@onready var animation2: AnimationPlayer = $animation2
@onready var animation: AnimationPlayer = $animation
@onready var area_col: Area2D = $area_col
@onready var sprite: Sprite2D = $spr
# @export var camera: Camera2D 
@onready var camera: Camera2D = $Camera2D
var zoom_tween: Tween
const JUMP_VELOCITY = -280.0
const SPEED = 200.0

var bullet_scene = preload("res://scenes/bullet.tscn")
var currentCheckpoint: Area2D

var isShooting = false
var isDoubleJump = true

var canDoubleJump = false
var canShoot = true

func _ready() -> void:
	Global.game_over.connect(_on_game_over)
	Global.new_game.connect(_on_new_game)
	Global.can_double_jump.connect(_on_can_double_jump)
	canDoubleJump = Global.canDoubleJump
	
	camera.zoom = Vector2(1.5, 1.5)

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
	elif Input.is_action_just_pressed("jump") and !is_on_floor() and isDoubleJump and canDoubleJump:
		velocity.y = JUMP_VELOCITY - 11
		isDoubleJump = false
	
	# Handle shoot
	if Input.is_action_pressed("shoot") and bullet_timer.is_stopped() and canShoot:
		shoot()
	
	# Animations when not shooting
	if not isShooting:
		if velocity.x != 0:
			animation.play("run")
		else:
			animation.play("idle")
	else:
		if velocity.x != 0:
			animation.play("run_shoot")
		else:
			animation.play("shoot")
	
	# Handle horizontal movement
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
		
		bullet_position.position.x = abs(bullet_position.position.x) * direction
	
		if direction < 0:
			bullet_position.rotation_degrees = 180
		else:
			bullet_position.rotation_degrees = 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)


# Handle shoot
func shoot():
	isShooting = true
	shoot_sound.play()
	
	var bullet = bullet_scene.instantiate()
	bullet.global_position = bullet_position.global_position
	bullet.global_rotation = bullet_position.global_rotation
	
	get_tree().root.add_child(bullet)
	bullet_timer.start()
	
	await bullet_timer.timeout
	isShooting = false

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

func collide_with_enemy(enemy: CharacterBody2D):
	canShoot = false
	$Explosion.play()
	
	set_collision_layer_value(2, false)
	area_col.set_collision_layer_value(2, false)
	enemy.set_collision_layer_value(3, false)
	
	Global.player_lives -= 1
	if Global.player_lives <= 0:
		Global.trigger_game_over()
		return
	animation2.play("enemy_col")
	
	var timer = get_tree().create_timer(2)
	timer.timeout.connect(func():
		set_collision_layer_value(2, true)
		area_col.set_collision_layer_value(2, true)
		enemy.set_collision_layer_value(3, true)
		$animation2.play("RESET")
		
		canShoot = true
	)

func _on_game_over():
	rotation_degrees = -90
	animation.play("idle")
	animation.play("die")
	
	set_physics_process(false)

func _on_new_game():
	canDoubleJump = false

func _on_can_double_jump():
	Global.canDoubleJump = true
	canDoubleJump = true

func _on_area_col_body_entered(body: Node2D) -> void:
	if body.is_in_group("cables"):
		$Explosion.play()
		position = currentCheckpoint.position

	if body.is_in_group("enemy"):
		var enemy = body as CharacterBody2D
		collide_with_enemy(enemy)

func _on_area_col_area_entered(area: Area2D) -> void:
	if area.is_in_group("checkpoint"):
		currentCheckpoint = area

func update_camera_zoom(target_zoom: Vector2, duration: float) -> void:
	if not camera:
		push_warning("There is no camera in the player")
		return
	if zoom_tween and zoom_tween.is_running():
		zoom_tween.kill()   
	zoom_tween = create_tween()
	zoom_tween.set_trans(Tween.TRANS_SINE)
	zoom_tween.set_ease(Tween.EASE_IN_OUT)
	zoom_tween.tween_property(camera, "zoom", target_zoom, duration)

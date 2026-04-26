extends Area2D

@export_file("*.tscn") var scene: String = "res://scenes/levels/world.tscn"
@export var tag: String = "spawn_bunker"
@onready var text: Label = $Label

var player_range: bool = false
var y_base: float

func _ready() -> void:
	text.hide()
	
	y_base = text.position.y
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	_animation()

func _unhandled_input(event: InputEvent) -> void:
	if player_range and event.is_action_pressed("ui_up"):
		_change_scene()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_range = true
		text.show()
		var fade_tween = create_tween()
		fade_tween.tween_property(text, "modulate:a", 1.0, 0.2)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_range = false
		text.hide()
		var fade_tween = create_tween()
		fade_tween.tween_property(text, "modulate:a", 0.0, 0.2)
		fade_tween.tween_callback(text.hide)

func _change_scene() -> void:
	if scene != "":
		await Fade.start_fade()
		if tag != "":
			Global.spawn_destino = tag
		get_tree().change_scene_to_file(scene)
		await Fade.end_fade()
	else:
		push_warning("Error: There is no handle on the door")

func _animation() -> void:
	var tween = create_tween().set_loops()
	tween.tween_property(text, "position:y", y_base - 4.0, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(text, "position:y", y_base, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

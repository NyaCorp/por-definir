extends Area2D
class_name CameraZone

@export var zoom_target: Vector2 = Vector2(1.5, 1.5)
@export var transition_duration: float = 1.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("update_camera_zoom"):
			body.update_camera_zoom(zoom_target, transition_duration)

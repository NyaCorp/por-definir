extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body as Player:
		Global.trigger_can_double_jump()
		queue_free()

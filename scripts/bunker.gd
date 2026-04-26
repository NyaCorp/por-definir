extends Node2D

func _on_start_final_stage_body_entered(body: Node2D) -> void:
	if body as Player:
		Global.trigger_start_final_stage()
		$StartFinalStage.queue_free()

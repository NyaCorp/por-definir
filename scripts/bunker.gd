extends Node2D

func _ready() -> void:
	$canvas_module.color = "#000000"
	Global.start_final_stage.connect(_on_trigger_start_final_staged_data)

func _on_start_final_stage_body_entered(body: Node2D) -> void:
	if body as Player:
		Global.trigger_start_final_stage()
		$StartFinalStage.queue_free()

func _on_trigger_start_final_staged_data():
	$canvas_module.color = "#c70000"

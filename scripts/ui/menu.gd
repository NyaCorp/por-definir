extends Control

func _on_play_btn_pressed() -> void:
	await Fade.start_fade()
	Global.trigger_new_game()
	get_tree().change_scene_to_file("res://scenes/levels/world.tscn")
	await Fade.end_fade()

func _on_credits_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/credits.tscn")

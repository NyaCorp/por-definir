extends Node

signal show_press_e_layer
signal hidden_press_e_layer
signal show_progress_layer
signal hidden_progress_layer
signal saved_data

signal start_final_stage
signal game_over
signal new_game

signal can_double_jump

var player_lives = 3
var isSavedData = false
var spawn_destino: String = ""

func _ready() -> void:
	game_over.connect(_on_game_over)
	new_game.connect(_on_new_game)

# Call signals
func trigger_show_press_e_layer(): show_press_e_layer.emit()
func trigger_hidden_press_e_layer(): hidden_press_e_layer.emit()
func trigger_show_progress_layer(): show_progress_layer.emit()
func trigger_hidden_progress_layer(): hidden_progress_layer.emit()

func trigger_saved_data(): saved_data.emit(); isSavedData = true
func trigger_start_final_stage(): start_final_stage.emit()
func trigger_can_double_jump(): can_double_jump.emit() 
func trigger_game_over(): game_over.emit()
func trigger_new_game(): new_game.emit()

func _on_game_over():
	$Music.stop()
	$GameOverSound.play()

func _on_new_game():
	$Music.play()
	player_lives = 3
	isSavedData = false

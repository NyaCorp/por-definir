extends Node

signal show_press_e_layer
signal hidden_press_e_layer
signal show_progress_layer
signal hidden_progress_layer

signal game_over

var player_lives = 3
var isSavedData = false

# Call signals
func trigger_show_press_e_layer(): show_press_e_layer.emit()
func trigger_hidden_press_e_layer(): hidden_press_e_layer.emit()
func trigger_show_progress_layer(): show_progress_layer.emit()
func trigger_hidden_progress_layer(): hidden_progress_layer.emit()

func trigger_game_over(): game_over.emit()

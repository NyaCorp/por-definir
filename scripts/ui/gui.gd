extends CanvasLayer

@onready var decrease_progress_timer: Timer = $ProgressLayer/DecreaseProgreessTimer
@onready var progress_timer: Timer = $ProgressLayer/PorgressTimer

@onready var progress_label: Label = $ProgressLayer/Progress
@onready var progress_layer: CanvasLayer = $ProgressLayer

@onready var press_e_layer: CanvasLayer = $PressE_Layer

var progress_count = 0

func _ready() -> void:
	hidden_press_e_layer()
	hidden_progress_layer()
	
	Global.connect("show_press_e_layer", show_press_e_layer)
	Global.connect("hidden_press_e_layer", hidden_press_e_layer)
	
	Global.connect("show_progress_layer", show_progress_layer)
	Global.connect("hidden_progress_layer", hidden_progress_layer)
	
func show_press_e_layer():
	press_e_layer.visible = true

func hidden_press_e_layer():
	press_e_layer.visible = false

func show_progress_layer():
	progress_layer.visible = true
	
	progress_timer.start()
	decrease_progress_timer.stop()
	
func hidden_progress_layer():
	progress_layer.visible = false
	
	decrease_progress_timer.start()
	progress_timer.stop()

func _on_porgress_timer_timeout() -> void:
	progress_count += 1
	progress_label.text = str(progress_count) + "%"
	
	if progress_count >= 100:
		Global.isSavedData = true
		progress_timer.stop()

func _on_decrease_progreess_timer_timeout() -> void:
	progress_count -= 1
	progress_label.text = str(progress_count) + "%"
	
	if progress_count <= 0:
		progress_count = 0
		decrease_progress_timer.stop()

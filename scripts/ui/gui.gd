extends CanvasLayer

@onready var decrease_progress_timer: Timer = $ProgressLayer/DecreaseProgreessTimer
@onready var progress_timer: Timer = $ProgressLayer/PorgressTimer

@onready var progress_label: Label = $ProgressLayer/Progress
@onready var progress_layer: CanvasLayer = $ProgressLayer
@onready var press_e_layer: CanvasLayer = $PressE_Layer

@onready var game_over_animation: AnimationPlayer = $GameOver/animation
@onready var game_over_layer: CanvasLayer = $GameOver

var progress_count = 0

func _ready() -> void:
	press_e_layer.visible = false
	progress_layer.visible = false
	game_over_layer.visible = false
	
	Global.game_over.connect(_on_game_over)
	
	Global.show_press_e_layer.connect(func(): press_e_layer.visible = true)
	Global.hidden_press_e_layer.connect(func(): press_e_layer.visible = false)
	Global.show_progress_layer.connect(func(): 
		progress_layer.visible = true
		progress_timer.start()
		decrease_progress_timer.stop()
	)
	Global.hidden_progress_layer.connect(func():
		progress_layer.visible = false
		decrease_progress_timer.start()
		progress_timer.stop()
	)

func _process(_delta: float) -> void:
	if Global.player_lives == 3:
		$"PlayerInfo/3".visible = true
		$"PlayerInfo/2".visible = false
		$"PlayerInfo/1".visible = false
	elif Global.player_lives == 2:
		$"PlayerInfo/3".visible = false
		$"PlayerInfo/2".visible = true
		$"PlayerInfo/1".visible = false
	elif Global.player_lives == 1:
		$"PlayerInfo/3".visible = false
		$"PlayerInfo/2".visible = false
		$"PlayerInfo/1".visible = true
	elif Global.player_lives == 0:
		$"PlayerInfo/3".visible = false
		$"PlayerInfo/2".visible = false
		$"PlayerInfo/1".visible = false
	
func _on_porgress_timer_timeout() -> void:
	progress_count += 1
	progress_label.text = str(progress_count) + "%"
	
	if progress_count >= 100:
		Global.trigger_saved_data()
		progress_timer.stop()

func _on_decrease_progreess_timer_timeout() -> void:
	progress_count -= 1
	progress_label.text = str(progress_count) + "%"
	
	if progress_count <= 0:
		progress_count = 0
		decrease_progress_timer.stop()

func _on_play_btn_pressed() -> void:
	Global.trigger_new_game()
	get_tree().reload_current_scene()

func _on_game_over():
	Global.trigger_hidden_press_e_layer()
	Global.trigger_hidden_progress_layer()
	
	game_over_layer.visible = true
	game_over_animation.play("game_over")

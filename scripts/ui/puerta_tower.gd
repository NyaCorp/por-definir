extends Area2D

@export_file("*.tscn") var escena_destino: String = "res://scenes/levels/tower.tscn"

@onready var texto_entrar: Label = $Label

var jugador_en_rango: bool = false
var posicion_y_base: float

func _ready() -> void:
	texto_entrar.hide()
	
	posicion_y_base = texto_entrar.position.y
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	_iniciar_animacion_flotante()

func _unhandled_input(event: InputEvent) -> void:
	if jugador_en_rango and event.is_action_pressed("ui_up"):
		_cambiar_escena()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		jugador_en_rango = true
		texto_entrar.show()
		var fade_tween = create_tween()
		fade_tween.tween_property(texto_entrar, "modulate:a", 1.0, 0.2)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		jugador_en_rango = false
		texto_entrar.hide()
		var fade_tween = create_tween()
		fade_tween.tween_property(texto_entrar, "modulate:a", 0.0, 0.2)
		fade_tween.tween_callback(texto_entrar.hide)

func _cambiar_escena() -> void:
	if escena_destino != "":
		get_tree().change_scene_to_file(escena_destino)
	else:
		push_warning("Error: No hay destino para la puerta")

func _iniciar_animacion_flotante() -> void:
	var tween = create_tween().set_loops()
	tween.tween_property(texto_entrar, "position:y", posicion_y_base - 4.0, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(texto_entrar, "position:y", posicion_y_base, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

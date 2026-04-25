extends Node2D

@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	if Global.spawn_destino != "":
		var punto_aparicion = get_node_or_null(Global.spawn_destino)
		if punto_aparicion != null:
			player.global_position = punto_aparicion.global_position
		else:
			push_warning("No se encontro un Marker2D con el nombre: " + Global.spawn_destino)
		  
		Global.spawn_destino = ""

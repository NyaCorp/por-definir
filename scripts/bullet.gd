extends Area2D

@export var speed = 600

func _process(delta: float) -> void:
	position += transform.x * speed * delta

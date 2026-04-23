extends Area2D

var speed = 600

func _process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.lives -= 1
		
		if body.lives <= 0:
			body.queue_free()
	
	queue_free()

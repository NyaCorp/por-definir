extends CanvasLayer

@onready var bg: ColorRect = $bg
var duration = 0.5

func _ready() -> void:
	bg.color.a = 0.0

func fade(target_alpha: float):
	var tween = create_tween()
	tween.tween_property(bg, "color:a", target_alpha, duration)
	return tween

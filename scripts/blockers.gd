extends StaticBody2D

func _ready() -> void:
	$col.disabled = true
	$spr.visible = false
	
	Global.saved_data.connect(_on_saved_data)

func _on_saved_data():
	$col.disabled = false
	$spr.visible = true

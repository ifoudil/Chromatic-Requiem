extends Node2D


func _ready():
	$AnimatedSprite2D.play("default")
	$AnimatedSprite2D.modulate = Color(0, 0, 0, 1)

	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color(1, 1, 1, 1), 1.0)

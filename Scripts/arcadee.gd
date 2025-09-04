extends Node2D


func _ready():
	$CharacterBody2D.set_physics_process(false)
	$AnimatedSprite2D2.visible = false
	$AnimatedSprite2D.play("default")
	modulate = Color(0, 0, 0, 1)
	

	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 1.0)
	await get_tree().create_timer(1).timeout
	$AnimatedSprite2D2.visible = true
	$AnimatedSprite2D2.play("default")
	await get_tree().create_timer(2.7).timeout
	$AnimatedSprite2D2.visible = false
	$CharacterBody2D.set_physics_process(true)


func _on_attack_timer_timeout() -> void:
	pass # Replace with function body.

extends Node2D


@onready var sprite = $AnimatedSprite2D

func _ready():
	$continuer.visible = false
	sprite.play("default")
	await get_tree().create_timer(3).timeout
		
	sprite.play("drip")
	await get_tree().create_timer(1.49).timeout
		
	sprite.play("default")
	await get_tree().create_timer(2).timeout
		
	sprite.play("continue")
	await get_tree().create_timer(0.74).timeout
		
	sprite.play("default2")
	await get_tree().create_timer(0.5).timeout
	sprite.play("flash")
	await get_tree().create_timer(0.6999).timeout
	sprite.play("flash2")
	$continuer.visible = true
	await get_tree().create_timer(2.99).timeout
	sprite.play("default2")

func _on_continuer_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/player.tscn")
	
	

extends Node2D


@onready var sprite = $AnimatedSprite2D

func _ready():
	while true:
		sprite.play("default")
		await get_tree().create_timer(5).timeout
		
		sprite.play("drip")
		await get_tree().create_timer(1.322).timeout
		
		sprite.play("default")
		await get_tree().create_timer(5).timeout

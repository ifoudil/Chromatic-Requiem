extends Node2D


@onready var sprite = $AnimatedSprite2D

func _ready():
		sprite.play("default")
		await get_tree().create_timer(3).timeout
		
		sprite.play("drip")
		await get_tree().create_timer(1.1366).timeout
		
		sprite.play("default")
		await get_tree().create_timer(2).timeout
		
		sprite.play("continue")
		await get_tree().create_timer(0.75).timeout
		
		sprite.play("default2")
	
		
		

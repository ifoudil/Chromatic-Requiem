extends Node2D

@onready var sprite = $AnimatedSprite2D
@onready var alarm = $AudioStreamPlayer2D
@onready var bubble = $AudioStreamPlayer2D2

func _ready():
	sprite.play("green")
	await get_tree().create_timer(1.5).timeout
	sprite.play("greenoff")
	await get_tree().create_timer(0.7).timeout
	sprite.play("black")
	await get_tree().create_timer(3).timeout
	sprite.play("red")
	await get_tree().create_timer(2).timeout
	sprite.play("redon")
	bubble.play()
	await get_tree().create_timer(3).timeout
	sprite.play("redalarm")
	alarm.play()
	
	await get_tree().create_timer(8).timeout
	alarm.stop()
	bubble.stop()
	sprite.play("black")
	await get_tree().create_timer(2).timeout
	sprite.play("skip1")
	await get_tree().create_timer(0.5).timeout
	sprite.play("skip2")
	await get_tree().create_timer(2.49).timeout
	sprite.play("skip3")
	await get_tree().create_timer(0.5).timeout

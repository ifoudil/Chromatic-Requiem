extends CharacterBody2D

# Variables de mouvement
var controls_enabled = true
@export var gravity = 950
@export var speed = 200
@export var acceleration = 0.2
@export var jump_force = 400
@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	sprite.play("idle_right")

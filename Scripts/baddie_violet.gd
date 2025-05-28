extends CharacterBody2D

# Variables de mouvement
var controls_enabled = true
@export var gravity = 950
@export var speed = 200
@export var acceleration = 0.2
@export var jump_force = 400
@onready var sprite = $AnimatedSprite2D
@onready var transition_timer = $AttackTimer


func _ready() -> void:
	sprite.play("idle_right")
	
	
func _physics_process(delta):
	if Input.is_action_just_pressed("atk"):
		transition_timer.start()
		$AnimatedSprite2D.play("atk1_right") 
	


func _on_attack_timer_timeout() -> void:
	sprite.play("idle_right")

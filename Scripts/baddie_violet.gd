extends CharacterBody2D
# Variables de mouvement
var controls_enabled = true
@export var gravity = 950
@export var speed = 200
@export var acceleration = 0.2
@export var jump_force = 400

# Variable pour bloquer l'attaque
var is_attacking = false

@onready var sprite = $AnimatedSprite2D
@onready var atk_timer = $AttackTimer
@onready var Mode_timer = $ModeTimer
@onready var demode_timer = $DemodeTimer

func _ready() -> void:
	sprite.play("idle_right")
	
func _physics_process(delta):
	# Bloquer l'attaque si une attaque est déjà en cours
	if Input.is_action_just_pressed("atk") and not is_attacking:
		is_attacking = true  # Bloquer les nouvelles attaques
		atk_timer.start()
		$AnimatedSprite2D.play("atk1_right") 

func _on_attack_timer_timeout() -> void:
	sprite.play("atk_stay")
	Mode_timer.start()

func _on_mode_timer_timeout() -> void:
	sprite.play("atk_demode")
	demode_timer.start()

func _on_demode_timer_timeout() -> void:
	$AnimatedSprite2D.play("idle_right")
	is_attacking = false  # Permettre de nouvelles attaques

extends CharacterBody2D

# Variables de mouvement
var controls_enabled = true
@export var gravity = 950
@export var speed = 200
@export var acceleration = 0.2
@export var jump_force = 400
@export var friction = 0.4

# Variable pour bloquer l'attaque
var is_attacking = false

# Variables pour le mouvement
var facing_right = true

@onready var sprite = $AnimatedSprite2D
@onready var atk_timer = $AttackTimer
@onready var Mode_timer = $ModeTimer
@onready var demode_timer = $DemodeTimer

func _ready() -> void:
	sprite.play("idle_right")
	
func _physics_process(delta):
	# Appliquer la gravité
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Gérer les contrôles seulement si ils sont activés et qu'on n'attaque pas
	if controls_enabled and not is_attacking:
		handle_movement()
	
	# Gérer l'attaque
	if Input.is_action_just_pressed("atk") and not is_attacking:
		is_attacking = true  # Bloquer les nouvelles attaques
		atk_timer.start()
		if facing_right:
			sprite.play("atk1_right")
		else:
			sprite.play("atk1_left")
	
	# Appliquer le mouvement
	move_and_slide()

func handle_movement():
	# Mouvement horizontal
	if Input.is_action_pressed("ui_right"):
		velocity.x = speed
		facing_right = true
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -speed
		facing_right = false
	else:
		velocity.x = 0
	
	# Saut
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -jump_force

func _on_attack_timer_timeout() -> void:
	sprite.play("atk_stay")
	Mode_timer.start()

func _on_mode_timer_timeout() -> void:
	sprite.play("atk_demode")
	demode_timer.start()

func _on_demode_timer_timeout() -> void:
	if facing_right:
		sprite.play("idle_right")
	else:
		sprite.play("idle_left")
	is_attacking = false  # Permettre de nouvelles attaques

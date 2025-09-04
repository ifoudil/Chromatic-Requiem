extends CharacterBody2D
# Variables de mouvement
var controls_enabled = true
@export var gravity = 450
@export var speed = 200
@export var acceleration = 0.2
@export var jump_force = 800
@export var friction = 0.4
# Variable pour bloquer l'attaque
var is_attacking = false
# Variable pour savoir si on fait un prejump
var is_prejumping = false
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
	
	# Gérer les contrôles seulement si ils sont activés
	if controls_enabled:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			is_prejumping = true
			controls_enabled = false
			$AnimatedSprite2D.play("prejump")
			await get_tree().create_timer(0.45).timeout
			is_prejumping = false
			controls_enabled = true
			
			velocity.y = -jump_force
	
		# Gérer l'attaque
		if Input.is_action_just_pressed("atk") and not is_attacking:
			is_attacking = true  # Bloquer les nouvelles attaques
			atk_timer.start()
			if facing_right:
				sprite.play("atk1_right")
			else:
				sprite.play("atk1_left")
		
		# Inputs de mouvement
		var direction = Input.get_axis("move_left", "move_right")
		
		# Mise à jour de la direction du regard
		if direction != 0:
			facing_right = direction > 0
		
		if direction != 0:
			velocity.x = lerp(velocity.x, direction * speed, acceleration)
		else:
			# Application de la friction
			if is_on_floor():
				velocity.x = lerp(velocity.x, 0.0, friction)
			else:
				velocity.x = lerp(velocity.x, 0.0, friction * 0.3)
	
	if !is_on_floor():
		velocity.y = clamp(velocity.y + gravity * delta, -500, 500)
	
	# Gestion des animations (seulement si pas en prejump ou en attaque)
	if not is_attacking and not is_prejumping:
		if not is_on_floor():  # En l'air
			sprite.play("jump")
		else:  # Au sol
			if facing_right:
				sprite.play("idle_right")
			else:
				sprite.play("idle_left")
	
	move_and_slide()
	
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

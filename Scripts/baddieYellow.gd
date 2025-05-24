extends CharacterBody2D

# Variables de mouvement
var controls_enabled = true
@export var gravity = 950
@export var speed = 200
@export var acceleration = 0.2
@export var jump_force = 400

# Variables d'animation et état
@onready var sprite = $AnimatedSprite2D
@onready var attack_timer = $AttackTimer
var facing_right = true
var is_attacking = false

# Variables pour le système d'idle spécial
var timer_started := false
var time_passed := 0.0
var reloading_started := false
var reloading_time := 0.0

func _ready() -> void:
	sprite.play("idle_right")

func _physics_process(delta):
	# Gravité
	if !is_on_floor():
		velocity.y = clamp(velocity.y + gravity * delta, -500, 500)
	
	# Direction de mouvement
	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		facing_right = direction > 0
	
	# Saut
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
	
	# Attaque
	if Input.is_action_just_pressed("atk") and !is_attacking:
		is_attacking = true
		attack_timer.start()
	
	# Mouvement horizontal
	velocity.x = lerp(velocity.x, direction * speed, acceleration)
	
	# Animation et mouvement
	update_animation(direction)
	move_and_slide()

func _process(delta):
	# Système d'idle spécial
	if Input.is_action_just_pressed("switch_idle") and not timer_started and not reloading_started and not is_attacking:
		timer_started = true
		time_passed = 0.0
	
	if timer_started:
		time_passed += delta
		if time_passed >= 10.0:
			timer_started = false
			reloading_started = true
			reloading_time = 0.0
	
	if reloading_started:
		reloading_time += delta
		if reloading_time >= 15.0:
			reloading_started = false

func update_animation(direction):
	# Déterminer le suffixe d'animation selon l'état
	var anim_suffix = ""
	if timer_started:
		anim_suffix = "2"  # Phase 1 : idle-right2 activé
	elif reloading_started:
		anim_suffix = "3"  # Phase 2 : reloading activé
	# Sinon anim_suffix reste vide pour les animations normales
	
	if is_attacking:
		sprite.play("atk1_right" + anim_suffix if facing_right else "atk1_left" + anim_suffix)
	elif is_on_floor():
		if direction == 0:
			# Pour l'idle, on gère spécialement les phases
			if timer_started:
				sprite.play("idle-right2")  # Animation spéciale idle
			elif reloading_started:
				sprite.play("reloading")  # Animation de reloading
			else:
				sprite.play("idle_right")  # Animation normale
		else:
			sprite.play("run_right" + anim_suffix if facing_right else "run_left" + anim_suffix)
	else:
		sprite.play("jump_right" + anim_suffix if facing_right else "jump_left" + anim_suffix)

func _on_attack_timer_timeout():
	is_attacking = false

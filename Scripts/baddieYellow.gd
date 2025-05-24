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
@onready var transition_timer = $TransitionTimer  # Timer pour les transitions
@onready var audio_transition_phase1 = $AudioStreamPlayer1  # Son transition vers phase 1
@onready var audio_phase1_start = $AudioStreamPlayer2       # Son début phase 1
@onready var audio_transition_phase2 = $AudioStreamPlayer3  # Son transition vers phase 2
@onready var audio_transition_normal = $AudioStreamPlayer4  # Son transition vers normal
var facing_right = true
var is_attacking = false

# Variables pour le système d'idle spécial
var timer_started := false
var time_passed := 0.0
var reloading_started := false
var reloading_time := 0.0

# Variables pour les transitions
var is_transitioning := false
var current_gameplay_state := "normal"  # "normal", "phase1", "phase2"
var next_gameplay_state := ""

# Les sons sont maintenant directement assignés aux AudioStreamPlayer dans l'éditeur

func _ready() -> void:
	sprite.play("idle_right")
	# Connecter le signal du timer de transition
	if not transition_timer.timeout.is_connected(_on_transition_timer_timeout):
		transition_timer.timeout.connect(_on_transition_timer_timeout)

func _physics_process(delta):
	# Ne traiter le mouvement que si on n'est pas en transition
	if not is_transitioning:
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
	# Système d'idle spécial (seulement si pas en transition)
	if not is_transitioning:
		if Input.is_action_just_pressed("switch_idle") and not timer_started and not reloading_started:
			start_transition_to_phase1()
		
		if timer_started:
			time_passed += delta
			if time_passed >= 4.0:
				start_transition_to_phase2()
		
		if reloading_started:
			reloading_time += delta
			if reloading_time >= 4.0:
				start_transition_to_normal()

func start_transition_to_phase1():
	"""Démarre la transition vers la phase 1"""
	is_transitioning = true
	next_gameplay_state = "phase1"
	sprite.play("transition_to_phase1")  # Animation de transition
	
	# Jouer le son de transition vers phase 1
	if audio_transition_phase1:
		audio_transition_phase1.play()
	
	transition_timer.wait_time = 1.6  # Durée de la transition
	transition_timer.start()

func start_transition_to_phase2():
	"""Démarre la transition vers la phase 2"""
	is_transitioning = true
	next_gameplay_state = "phase2"
	timer_started = false
	sprite.play("transition_to_phase2")  # Animation de transition
	
	# Arrêter le son de la phase 1 s'il joue encore
	if audio_phase1_start and audio_phase1_start.playing:
		audio_phase1_start.stop()
	
	# Jouer le son de transition vers phase 2
	if audio_transition_phase2:
		audio_transition_phase2.play()
	
	transition_timer.wait_time = 1.6 # Durée de la transition
	transition_timer.start()

func start_transition_to_normal():
	"""Démarre la transition vers l'état normal"""
	is_transitioning = true
	next_gameplay_state = "normal"
	reloading_started = false
	sprite.play("transition_to_normal")  # Animation de transition
	
	# Jouer le son de transition vers normal
	if audio_transition_normal:
		audio_transition_normal.play()
	
	transition_timer.wait_time = 1.3  # Durée de la transition
	transition_timer.start()

func _on_transition_timer_timeout():
	"""Appelée quand la transition est terminée"""
	is_transitioning = false
	
	# Changer l'état de gameplay
	match next_gameplay_state:
		"phase1":
			current_gameplay_state = "phase1"
			timer_started = true
			time_passed = 0.0
			
			# Jouer le son de début de phase 1
			if audio_phase1_start:
				audio_phase1_start.play()
			
		"phase2":
			current_gameplay_state = "phase2"
			reloading_started = true
			reloading_time = 0.0
			# Effet visuel ou sonore optionnel
		"normal":
			current_gameplay_state = "normal"
			# Effet visuel ou sonore optionnel
	
	# Reprendre l'animation normale
	update_animation(0)  # 0 pour idle

func update_animation(direction):
	if is_transitioning:
		return

	# Déterminer le suffixe d'animation selon l'état
	var anim_suffix = ""
	match current_gameplay_state:
		"phase1":
			anim_suffix = "2"
		"phase2":
			anim_suffix = "3"
		"normal":
			anim_suffix = ""

	if is_attacking:
		sprite.play("atk1_right" + anim_suffix if facing_right else "atk1_left" + anim_suffix)
	elif is_on_floor():
		if direction == 0:
			sprite.play("idle_right" + anim_suffix if facing_right else "idle_left" + anim_suffix)
		else:
			sprite.play("run_right" + anim_suffix if facing_right else "run_left" + anim_suffix)
	else:
		sprite.play("jump_right" + anim_suffix if facing_right else "jump_left" + anim_suffix)

func _on_attack_timer_timeout():
	is_attacking = false

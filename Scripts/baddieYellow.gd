extends CharacterBody2D

# Variables de mouvement
var controls_enabled = true
@export var gravity = 950
@export var speed = 200
@export var acceleration = 0.2
@export var jump_force = 400
@export var friction = 0.4

# Variables d'animation et état
@onready var sprite = $AnimatedSprite2D
@onready var attack_timer = $AttackTimer
@onready var transition_timer = $TransitionTimer
@onready var audio_transition_phase1 = $AudioStreamPlayer1
@onready var audio_phase1_start = $AudioStreamPlayer2
@onready var audio_transition_phase2 = $AudioStreamPlayer3
@onready var audio_transition_normal = $AudioStreamPlayer4
@onready var audio_atk_surchage = $AudioStreamPlayer5
var facing_right = true
var is_attacking = false

# Variables pour les projectiles
@onready var projectile_area = $projectile # Ton Area2D déjà positionné
var is_shooting_projectiles = false
var projectile_initial_position: Vector2
var has_shot_this_frame = false  # Pour éviter les tirs multiples

# Variables pour le système d'idle spécial
var timer_started := false
var time_passed := 0.0
var reloading_started := false
var reloading_time := 0.0

# Variables pour les transitions
var is_transitioning := false
var current_gameplay_state := "normal"
var next_gameplay_state := ""

func _ready() -> void:
	sprite.play("idle_right")
	if not transition_timer.timeout.is_connected(_on_transition_timer_timeout):
		transition_timer.timeout.connect(_on_transition_timer_timeout)
	
	# Connecter les signaux d'animation
	if not sprite.animation_finished.is_connected(_on_animation_finished):
		sprite.animation_finished.connect(_on_animation_finished)
	if not sprite.frame_changed.is_connected(_on_frame_changed):
		sprite.frame_changed.connect(_on_frame_changed)
	
	# Sauvegarder la position initiale du projectile
	if projectile_area:
		projectile_initial_position = projectile_area.position

func _physics_process(delta):
	# Gravité (toujours appliquée)
	if !is_on_floor():
		velocity.y = clamp(velocity.y + gravity * delta, -500, 500)
	
	# Si on est en transition, bloquer tous les mouvements sauf la gravité
	if is_transitioning:
		# Freiner progressivement jusqu'à l'arrêt complet
		velocity.x = lerp(velocity.x, 0.0, 0.8)
		move_and_slide()
		return
	
	# Inputs de mouvement (seulement si pas en transition)
	var direction = Input.get_axis("move_left", "move_right")
	
	# Mise à jour de la direction du regard
	if direction != 0:
		facing_right = direction > 0
	
	# Saut (seulement si pas en transition)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
	
	# Attaque (seulement si pas en transition)
	if Input.is_action_just_pressed("atk") and !is_attacking:
		is_attacking = true
		attack_timer.start()
		
		# Jouer l'audio d'attaque spécifique à la phase 1
		if current_gameplay_state == "phase1" and audio_atk_surchage:
			audio_atk_surchage.play()
		
		# Si on est en phase1, préparer le tir de projectiles
		if current_gameplay_state == "phase1":
			is_shooting_projectiles = true
			has_shot_this_frame = false  # Reset pour la nouvelle attaque
	
	# Mouvement horizontal
	if direction != 0:
		velocity.x = lerp(velocity.x, direction * speed, acceleration)
	else:
		# Application de la friction
		if is_on_floor():
			velocity.x = lerp(velocity.x, 0.0, friction)
		else:
			velocity.x = lerp(velocity.x, 0.0, friction * 0.3)
	
	# Animation
	update_animation(direction)
	
	move_and_slide()

func _process(delta):
	# Système d'idle spécial (seulement si pas en transition ET au sol)
	if not is_transitioning:
		# La transition ne peut se déclencher QUE si on est au sol
		if Input.is_action_just_pressed("switch_idle") and not timer_started and not reloading_started and is_on_floor():
			start_transition_to_phase1()
		
		if timer_started:
			time_passed += delta
			# La transition vers phase2 ne peut se faire QUE si on est au sol
			if time_passed >= 15.0 and is_on_floor():
				start_transition_to_phase2()
		
		if reloading_started:
			reloading_time += delta
			# La transition vers normal ne peut se faire QUE si on est au sol
			if reloading_time >= 10.0 and is_on_floor():
				start_transition_to_normal()

func _on_frame_changed():
	"""Appelée à chaque changement de frame d'animation"""
	# Vérifier si on est dans l'animation d'attaque phase1
	if is_shooting_projectiles and sprite.animation == ("atk1_right2" if facing_right else "atk1_left2"):
		# Méthode simplifiée : tirer à la frame 2 ou 3 (ajuste selon ton animation)
		var target_frame = 2  # Ajuste cette valeur selon ta frame de tir
		
		if sprite.frame == target_frame and not has_shot_this_frame:
			shoot_projectile()
			has_shot_this_frame = true

func _on_animation_finished():
	"""Appelée quand une animation se termine"""
	# Reset le flag pour permettre un nouveau tir à la prochaine animation
	if sprite.animation == ("atk1_right2" if facing_right else "atk1_left2"):
		has_shot_this_frame = false

func shoot_projectile():
	"""Lance le projectile depuis sa position initiale"""
	if not projectile_area:
		print("Aucun Area2D de projectile trouvé!")
		return
	
	print("Tir de projectile!")  # Debug
	
	# Remettre le projectile à sa position initiale
	projectile_area.position = projectile_initial_position
	projectile_area.visible = true  # S'assurer qu'il est visible
	
	# Configurer la direction du projectile selon le regard du personnage
	var direction = 1 if facing_right else -1
	
	# Si ton projectile a une méthode pour définir sa direction
	if projectile_area.has_method("launch"):
		projectile_area.launch(direction)
		print("Méthode launch appelée avec direction: ", direction)
	elif projectile_area.has_method("set_direction"):
		projectile_area.set_direction(direction)
		print("Méthode set_direction appelée avec direction: ", direction)
	else:
		print("Aucune méthode de lancement trouvée sur le projectile")

func start_transition_to_phase1():
	"""Démarre la transition vers la phase 1 (seulement au sol)"""
	if not is_on_floor():
		return
		
	is_transitioning = true
	next_gameplay_state = "phase1"
	sprite.play("transition_to_phase1")
	
	if audio_transition_phase1:
		audio_transition_phase1.play()
	
	transition_timer.wait_time = 1.6
	transition_timer.start()

func start_transition_to_phase2():
	"""Démarre la transition vers la phase 2 (seulement au sol)"""
	if not is_on_floor():
		return
		
	is_transitioning = true
	next_gameplay_state = "phase2"
	timer_started = false
	sprite.play("transition_to_phase2")
	
	if audio_phase1_start and audio_phase1_start.playing:
		audio_phase1_start.stop()
	
	if audio_transition_phase2:
		audio_transition_phase2.play()
	
	transition_timer.wait_time = 1.6
	transition_timer.start()

func start_transition_to_normal():
	"""Démarre la transition vers l'état normal (seulement au sol)"""
	if not is_on_floor():
		return
		
	is_transitioning = true
	next_gameplay_state = "normal"
	reloading_started = false
	sprite.play("transition_to_normal")
	
	if audio_transition_normal:
		audio_transition_normal.play()
	
	transition_timer.wait_time = 1.3
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
			
			if audio_phase1_start:
				audio_phase1_start.play()
			
		"phase2":
			current_gameplay_state = "phase2"
			reloading_started = true
			reloading_time = 0.0
		"normal":
			current_gameplay_state = "normal"
			# Arrêter les projectiles si on revient en mode normal
			is_shooting_projectiles = false

func update_animation(direction):
	# Si on est en transition, laisser l'animation de transition
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

	# Animations basées sur l'état réel
	if is_attacking:
		sprite.play("atk1_right" + anim_suffix if facing_right else "atk1_left" + anim_suffix)
	elif !is_on_floor():
		sprite.play("jump_right" + anim_suffix if facing_right else "jump_left" + anim_suffix)
	elif abs(velocity.x) > 10:
		sprite.play("run_right" + anim_suffix if facing_right else "run_left" + anim_suffix)
	else:
		sprite.play("idle_right" + anim_suffix if facing_right else "idle_left" + anim_suffix)

func _on_attack_timer_timeout():
	is_attacking = false
	# Arrêter les projectiles quand l'attaque se termine
	is_shooting_projectiles = false
	has_shot_this_frame = false

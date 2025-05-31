extends Area2D

# Force du rebond (ajuste selon tes besoins)
@export var bounce_force: float = -800.0
# Multiplicateur horizontal pour garder le mouvement latéral
@export var horizontal_multiplier: float = 0.3

@onready var animated_sprite = $AnimatedSprite2D

# Pour éviter les rebonds multiples
var bounced_bodies = {}
var cooldown_time = 0.5

func _ready():
	# Connecter le signal quand un corps entre dans l'area
	body_entered.connect(_on_body_entered)
	# Optionnel: détecter quand le corps sort pour reset le cooldown plus tôt
	body_exited.connect(_on_body_exited)
	animated_sprite.play("default") 

func _on_body_entered(body):
	# Vérifier que le corps a une vélocité (RigidBody2D ou CharacterBody2D)
	if body.has_method("set_velocity") or body.has_method("apply_impulse"):
		# Vérifier le cooldown
		if not bounced_bodies.has(body):
			_bounce_body(body)

func _bounce_body(body):
	# Marquer le corps comme ayant rebondi
	bounced_bodies[body] = true
	
	# Animation du trampoline
	if animated_sprite:
		animated_sprite.play("bounce") # Remplace par le nom de ton animation
	
	# Appliquer la force selon le type de corps
	if body is RigidBody2D:
		# Pour RigidBody2D, utiliser apply_impulse
		var current_velocity = body.linear_velocity
		var bounce_impulse = Vector2(current_velocity.x * horizontal_multiplier, bounce_force)
		body.apply_impulse(bounce_impulse)
		
	elif body is CharacterBody2D:
		# Pour CharacterBody2D, modifier directement la vélocité
		var current_velocity = body.velocity
		body.velocity = Vector2(current_velocity.x * horizontal_multiplier, bounce_force)
	
	# Son de rebond (optionnel)
	_play_bounce_sound()
	
	# Timer pour réinitialiser le cooldown
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = cooldown_time
	timer.one_shot = true
	timer.timeout.connect(_reset_cooldown.bind(body, timer))
	timer.start()

func _on_body_exited(body):
	# Optionnel: reset immédiat quand le corps sort de l'area
	if bounced_bodies.has(body):
		bounced_bodies.erase(body)

func _reset_cooldown(body, timer):
	animated_sprite.play("default") 
	# Supprimer le corps de la liste des corps ayant rebondi
	if bounced_bodies.has(body):
		bounced_bodies.erase(body)
	# Supprimer le timer
	timer.queue_free()

func _play_bounce_sound():
	# Si tu as un AudioStreamPlayer2D comme enfant
	var audio_player = get_node_or_null("AudioStreamPlayer2D")
	if audio_player and audio_player.stream:
		audio_player.play()

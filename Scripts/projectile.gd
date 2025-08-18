# Projectile.gd
extends Area2D

@onready var sprite = $AnimatedSprite2D
@export var speed = 400
var direction = Vector2.RIGHT
var time_alive = 0.0
var invisibility_duration = 1.0

func _ready():
	sprite.play("default")
	modulate.a = 0.0
	# Ou alternativement : visible = false
	

func _physics_process(delta):
	time_alive += delta  # Corrigé : += au lieu de =+
	
	# Rendre visible après 1 seconde
	if time_alive >= invisibility_duration and modulate.a == 0.0:
		modulate.a = 1.0
		# Ou alternativement : visible = true
	
	position += direction * speed * delta

func _on_body_entered(body):
	if body.is_in_group("enemy"):  # Optionnel : ajouter les ennemis à un groupe
		body.take_damage(1)  # Fonction à définir dans le script ennemi
		queue_free()

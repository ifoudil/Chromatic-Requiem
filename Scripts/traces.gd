extends Sprite2D

@onready var character = $"../characterBody2D"
var is_mark_active = false

func _ready():
	visible = false

func _process(_delta):
	# Vérifier si le personnage vient de sauter
	if character.is_prejumping and not is_mark_active:
		create_jump_mark()

func create_jump_mark():
	is_mark_active = true
	
	# Se positionner à l'endroit du personnage
	global_position = character.global_position + Vector2(-12,-54 )
	visible = true
	modulate = Color(1, 1, 1, 1)  # Opaque
	
	# Attendre 3 secondes
	await get_tree().create_timer(3.0).timeout
	
	# Dégradation sur 1 seconde
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 1.0)
	await tween.finished
	
	# Cacher et permettre un nouveau mark
	visible = false
	is_mark_active = false

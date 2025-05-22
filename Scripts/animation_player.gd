extends AnimationPlayer

var play_pressed = false

func _ready():
	# Cache le bouton Play au départ (utilise le bon chemin)
	$"../splashScreen/play".visible = false
	$"../splashScreen/play".disabled = true
	
	# Connecte le signal du bouton
	
	# Connecte le signal d'animation terminée
	
	# Joue l'animation d'ouverture
	play("open")

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "open":
		# L'animation d'ouverture est finie, affiche et active le bouton Play
		$"../splashScreen/play".visible = true
		$"../splashScreen/play".disabled = false
	
	elif anim_name == "play" and play_pressed:
		# L'animation Play est finie, change de scène
		get_tree().change_scene_to_file("res://Scenes/player.tscn")

func _on_play_pressed() -> void:
	# Dès qu'on clique sur Play
	play_pressed = true
	$"../splashScreen/play".disabled = true  # Désactive le bouton pour éviter les clics multiples
	play("play")

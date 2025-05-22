extends AnimationPlayer

var play_pressed = false

func _ready():
	$"../VBoxContainer/Play".pressed.connect(_on_play_pressed)
	
	animation_finished.connect(_on_animation_finished)
	play("open")  # Animation au démarrage

func _on_play_pressed():  # Corrigé les astérisques
	play_pressed = true
	play("play")

func _on_animation_finished(anim_name):  # Corrigé les astérisques
	if anim_name == "play" and play_pressed:
		# Change vers la scène "player"
		get_tree().change_scene_to_file("res://Scenes/player.tscn")

extends AnimationPlayer

var play_pressed = false

func _ready():
	$"../splashScreen/play".visible = false
	$"../splashScreen/play".disabled = true
	play("open")

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "open":
		$"../splashScreen/play".visible = true
		$"../splashScreen/play".disabled = false
	
	elif anim_name == "play" and play_pressed:
		get_tree().change_scene_to_file("res://Scenes/intro.tscn")

func _on_play_pressed() -> void:
	play_pressed = true
	$"../splashScreen/play".disabled = true 
	play("play")

extends CanvasLayer

var menu = null

func _ready():
	menu = $TextureRect
	remove_child(menu)  # On retire le menu au lancement, il n'existe plus dans la scène

func _on_pause_pressed() -> void:
	if menu.get_parent() == null:
		# Ouvrir le menu pause
		add_child(menu) 
	 # On ajoute le menu à CanvasLayer → il apparaît + interactif
		
		# FREEZER TOUT LE JEU
		get_tree().paused = true
		
	else:
		# Fermer le menu pause
		remove_child(menu)  
		
		# REPRENDRE LE JEU
		get_tree().paused = false

func _on_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/player.tscn")
	

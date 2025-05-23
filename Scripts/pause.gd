extends CanvasLayer

var menu = null

func _ready():
	menu = $TextureRect
	remove_child(menu)  # On retire le menu au lancement, il n’existe plus dans la scène

func _on_pause_pressed() -> void:
	if menu.get_parent() == null:
		add_child(menu)  # On ajoute le menu à CanvasLayer → il apparaît + interactif
	else:
		remove_child(menu)  # On enlève le menu → il disparaît + plus d’interaction

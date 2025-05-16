extends CollisionShape2D

var menu_scene = preload("res://chemin/vers/ton_menu.tscn")
var menu_instance = null

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.name == "Player":  # adapte selon le nom de ton joueur
		if menu_instance == null:
			menu_instance = menu_scene.instantiate()
			get_tree().current_scene.add_child(menu_instance)
		else:
			menu_instance.visible = true

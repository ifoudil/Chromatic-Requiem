extends Area2D

var menu_scene = preload("res://Scenes/menu_2.tscn")
var menu_instance = null

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	print("Collision with ", body.name)
	if body.name == "CharacterBody2D":
		menu_instance = menu_scene.instantiate()
		get_tree().current_scene.add_child(menu_instance)
		get_tree().paused = true

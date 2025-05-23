extends CanvasLayer

func _ready():
	$AnimatedSprite2D.play("default") 
	$VBoxContainer/map.disabled = false
	$VBoxContainer/Quitter.disabled = false

func _on_quitter_pressed() -> void:
	$AnimatedSprite2D.play("default") 
	$VBoxContainer/map.disabled = false
	$VBoxContainer/Quitter.disabled = false
	self.visible = false

func _on_map_pressed() -> void:
	$AnimatedSprite2D.play("map") 
	$VBoxContainer/map.disabled = true


func _on_lvl_1_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/lvl1.tscn")

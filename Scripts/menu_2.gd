extends CanvasLayer

func _ready():
	$AnimatedSprite2D.play("default") 
	$VBoxContnnnainer/map.disabled = false
	$VBoxContainer/Quitter.disabled = false
	$lvl1.disabled = true
	$lvl2.disabled = true

func _on_quitter_pressed() -> void:
	$AnimatedSprite2D.play("default") 
	$VBoxContainer/map.disabled = false
	$VBoxContainer/Quitter.disabled = false
	self.visible = false

func _on_map_pressed() -> void:
	$AnimatedSprite2D.play("map") 
	$VBoxContainer/map.disabled = true
	$lvl1.disabled = false
	$lvl2.disabled = false


func _on_lvl_1_pressed() -> void:
	self.visible = false
	get_tree().change_scene_to_file("res://Scenes/lvl1.tscn")


func _on_lvl_2_pressed() -> void:
	self.visible = false
	get_tree().change_scene_to_file("res://Scenes/lvl2.tscn")

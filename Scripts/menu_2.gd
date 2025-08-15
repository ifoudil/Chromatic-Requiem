extends CanvasLayer

func _ready():
	$AnimatedSprite2D.play("default") 
	$map.disabled = false
	$Quitter.disabled = false
	$arcade.disabled = false
	$lvl1.disabled = true
	$lvl2.disabled = true
	get_tree().paused = true

func _on_quitter_pressed() -> void:
	$AnimatedSprite2D.play("default") 
	$map.disabled = false
	$Quitter.disabled = false
	$arcade.disabled = true
	self.visible = false
	get_tree().paused = false

func _on_map_pressed() -> void:
	$AnimatedSprite2D.play("map") 
	$map.disabled = true
	$arcade.disabled = true
	$lvl1.disabled = false
	$lvl2.disabled = false


func _on_lvl_1_pressed() -> void:
	self.visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/lvl1.tscn")


func _on_lvl_2_pressed() -> void:
	self.visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/lvl2.tscn")


func _on_arcade_pressed() -> void:
	pass

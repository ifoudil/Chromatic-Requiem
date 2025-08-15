extends CanvasLayer

var is_animating = false

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
	is_animating = true
	
	$AnimatedSprite2D.play("lvl1down") 
	await get_tree().create_timer(0.39).timeout
	$AnimatedSprite2D.play("lvl1up") 
	await get_tree().create_timer(0.59).timeout
	self.visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/lvl1.tscn")

func _on_lvl_1_mouse_entered() -> void:
	if is_animating:
		return
	
	await get_tree().create_timer(0.1).timeout
	if not is_animating:
		$AnimatedSprite2D.play("lvl1") 

func _on_lvl_1_mouse_exited() -> void:
	if is_animating:
		return
		
	await get_tree().create_timer(0.1).timeout
	if not is_animating:
		$AnimatedSprite2D.play("map") 
	
func _on_lvl_2_pressed() -> void:
	self.visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/lvl2.tscn")

func _on_arcade_pressed() -> void:
	pass

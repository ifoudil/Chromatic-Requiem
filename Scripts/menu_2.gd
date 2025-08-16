extends CanvasLayer


var is_animating = false
var no = false

func _ready():
	no = false
	$ColorRect.modulate = Color(1, 1, 1, 0.3)
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
	$arcade.disabled = false
	self.visible = false
	get_tree().paused = false

func _on_map_pressed() -> void:
	$AnimatedSprite2D.play("map") 
	$map.disabled = true
	$arcade.disabled = true
	$lvl1.disabled = false
	$lvl2.disabled = false
	var no = true

func _on_map_mouse_entered() -> void:
	if no:
		
		return
		
	if not no:
		$AnimatedSprite2D.play("holdadv")


func _on_map_mouse_exited() -> void:
	if no:
		return
		
	await get_tree().create_timer(0.05).timeout
	if not no:
		$AnimatedSprite2D.play("default")




func _on_lvl_1_pressed() -> void:
	is_animating = true
	
	$AnimatedSprite2D.play("lvl1down") 
	await get_tree().create_timer(0.39).timeout
	$AnimatedSprite2D.play("lvl1up") 
	await get_tree().create_timer(0.59).timeout
	
	$AnimatedSprite2D.modulate = Color(1, 1, 1, 1)
	
	var tween1 = create_tween()
	var tween2 = create_tween()
	
	tween1.tween_property($AnimatedSprite2D, "modulate", Color(0, 0, 0, 1), 1.0)
	tween2.tween_property($ColorRect, "modulate", Color(0, 0, 0, 1), 1.0)
	
	
	await get_tree().create_timer(1.0).timeout
	
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
	is_animating = true
	
	
	$AnimatedSprite2D.play("lvl2down") 
	await get_tree().create_timer(0.39).timeout
	$AnimatedSprite2D.play("lvl2up") 
	await get_tree().create_timer(0.59).timeout
	
	$AnimatedSprite2D.modulate = Color(1, 1, 1, 1)
	
	var tween1 = create_tween()
	var tween2 = create_tween()
	
	tween1.tween_property($AnimatedSprite2D, "modulate", Color(0, 0, 0, 1), 1.0)
	tween2.tween_property($ColorRect, "modulate", Color(0, 0, 0, 1), 1.0)
	
	
	await get_tree().create_timer(1.0).timeout
	
	self.visible = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/lvl2.tscn")




func _on_lvl_2_mouse_entered() -> void:
	if is_animating:
		return
	
	await get_tree().create_timer(0.1).timeout
	if not is_animating:
		$AnimatedSprite2D.play("lvl2") 
		
func _on_lvl_2_mouse_exited() -> void:
	if is_animating:
		return
		
	await get_tree().create_timer(0.1).timeout
	if not is_animating:
		$AnimatedSprite2D.play("map")
	
	
func _on_arcade_pressed() -> void:
	pass


func _on_arcade_mouse_entered() -> void:
	await get_tree().create_timer(0.05).timeout
	$AnimatedSprite2D.play("holdarcade")


func _on_arcade_mouse_exited() -> void:
	await get_tree().create_timer(0.05).timeout
	$AnimatedSprite2D.play("default")

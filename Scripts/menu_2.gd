extends CanvasLayer

var is_animating = false

func _ready():
	$ColorRect.modulate = Color(1, 1, 1, 0.3)
	$AnimatedSprite2D.play("default") 
	$map.visible = true
	$Quitter.visible = true
	$arcade.visible = true
	# Niveaux cachés
	$lvl1.visible = false
	$lvl2.visible = false
	get_tree().paused = true

func _on_quitter_pressed() -> void:
	$AnimatedSprite2D.play("default") 
	$map.visible = true
	$Quitter.visible = true
	$arcade.visible = true
	$lvl1.visible = false
	$lvl2.visible = false
	self.visible = false
	get_tree().paused = false

func _on_quitter_mouse_entered() -> void:
	if is_animating:  # Bloquer si animation en cours
		return
	if $arcade.visible:
		$AnimatedSprite2D.play("holdquit") 
	if $lvl2.visible:
		$AnimatedSprite2D.play("holdquit2") 

func _on_quitter_mouse_exited() -> void:
	if is_animating:  # Bloquer si animation en cours
		return
	if $lvl2.visible:
		$AnimatedSprite2D.play("map") 
	else:
		$AnimatedSprite2D.play("default") 

func _on_map_pressed() -> void:
	$AnimatedSprite2D.play("map") 
	$map.visible = false
	$arcade.visible = false
	$lvl1.visible = true
	$lvl2.visible = true

func _on_map_mouse_entered() -> void:
	if not $map.visible or is_animating:
		return
	$AnimatedSprite2D.play("holdadv")

func _on_map_mouse_exited() -> void:
	if not $map.visible or is_animating:
		return
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
	if not $lvl1.visible or is_animating:  # Ajouter is_animating
		return
	$AnimatedSprite2D.play("lvl1") 

func _on_lvl_1_mouse_exited() -> void:
	if not $lvl1.visible or is_animating:  # Ajouter is_animating
		return
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
	if not $lvl2.visible or is_animating:  # Ajouter is_animating
		return
	$AnimatedSprite2D.play("lvl2") 
		
func _on_lvl_2_mouse_exited() -> void:
	if not $lvl2.visible or is_animating:  # Ajouter is_animating
		return
	$AnimatedSprite2D.play("map")
	
func _on_arcade_pressed() -> void:
	is_animating = true
	get_tree().paused = false
	$AnimatedSprite2D.modulate = Color(1, 1, 1, 1)
	var next_scene = load("res://Scenes/arcade.tscn")
	
	var tween1 = create_tween()
	var tween2 = create_tween()
	
	tween1.tween_property($AnimatedSprite2D, "modulate", Color(0, 0, 0, 1), 1.0)
	tween2.tween_property($ColorRect, "modulate", Color(0, 0, 0, 1), 1.0)
	
	# Attendre que l'animation se termine avant de changer de scène
	await tween1.finished
	get_tree().change_scene_to_file("res://Scenes/arcade.tscn")

func _on_arcade_mouse_entered() -> void:
	if not $arcade.visible or is_animating:  # Ajouter is_animating
		return
	$AnimatedSprite2D.play("holdarcade")

func _on_arcade_mouse_exited() -> void:
	if not $arcade.visible or is_animating:  # Ajouter is_animating
		return
	$AnimatedSprite2D.play("default")

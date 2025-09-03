extends Node2D


func _on_area_2d_3_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://Scenes/drip.tscn")
	

func _ready() -> void:
	$AnimatedSprite2D.play("default") 
	modulate = Color(0, 0, 0, 1)  # self.modulate, pas $lvl1.modulate
	
	var tween1 = create_tween()
	
	# Animer directement ce node (self)
	tween1.tween_property(self, "modulate", Color(1, 1, 1, 1), 1.0)

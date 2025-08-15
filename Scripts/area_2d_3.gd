extends Area2D
	


func _on_body_entered(body: Node2D) -> void:
	call_deferred("_change_scene")
	
func _change_scene() -> void:
	get_tree().change_scene_to_file("res://Scenes/drip.tscn")
	

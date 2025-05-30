extends CanvasLayer

func _ready():
	$AnimatedSprite2D.play("default") 
	$Control.visible = false

func _on_quitter_pressed() -> void:
	$AnimatedSprite2D.play("default") 
	self.visible = false
	get_tree().paused = false

func _on_info_pressed() -> void:
	$AnimatedSprite2D.play("histoire")
	$VBoxContainer.visible = false
	$Control.visible = true
	$Control/pink.visible = false
	$Control/yellow.visible = false


func _on_microships_pressed() -> void:
	$AnimatedSprite2D.play("info")
	$VBoxContainer.visible = false
	$Control.visible = true
	$Control/pink.visible = true
	$Control/yellow.visible = true


func _on_return_pressed() -> void:
	$Control.visible = false
	$VBoxContainer.visible = true
	$AnimatedSprite2D.play("default") 


func _on_pink_pressed() -> void:
	$AnimatedSprite2D.play("microship_pink") 
	$VBoxContainer.visible = false
	$Control/pink.visible = false
	$Control/yellow.visible = false


func _on_yellow_pressed() -> void:
	$AnimatedSprite2D.play("microship_yellow") 
	$VBoxContainer.visible = false
	$Control/pink.visible = false
	$Control/yellow.visible = false

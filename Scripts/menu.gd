extends CanvasLayer

func _ready():
	$AnimatedSprite2D.play("default") 

func _on_quitter_pressed() -> void:
	$AnimatedSprite2D.play("default") 
	self.visible = false

func _on_info_pressed() -> void:
	$AnimatedSprite2D.play("info")


func _on_microships_pressed() -> void:
	$AnimatedSprite2D.play("microships")

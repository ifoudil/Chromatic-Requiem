extends CharacterBody2D

@export var speed = 200
@export var jump_force = -400
@export var gravity = 900

func _physics_process(delta):
	var velocity = self.velocity

	# Appliquer la gravité
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_force
			$AnimatedSprite2D.animation = "jump"
			$AnimatedSprite2D.play()

	# Déplacement horizontal
	if Input.is_action_pressed("move_right"):
		velocity.x = speed
		if is_on_floor():
			$AnimatedSprite2D.animation = "walk_right"
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play()
	elif Input.is_action_pressed("move_left"):
		velocity.x = -speed
		if is_on_floor():
			$AnimatedSprite2D.animation = "walk_left"
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play()
	else:
		velocity.x = 0
		if is_on_floor():
			$AnimatedSprite2D.animation = "defaultr"
			$AnimatedSprite2D.play()

	self.velocity = velocity
	move_and_slide()

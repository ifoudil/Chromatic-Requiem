extends CharacterBody2D
var controls_enabled = true


@export var gravity = 950
@export var speed = 200
@export var acceleration = 0.2
@export var jump_force = 600

@onready var sprite = $AnimatedSprite2D
@onready var attack_timer = $AttackTimer

var facing_right = true
var is_attacking = false

func _physics_process(delta):
	if !is_on_floor():
		velocity.y = clamp(velocity.y + gravity * delta, -500, 500)

	var direction = Input.get_axis("move_left", "move_right")
	if direction != 0:
		facing_right = direction > 0

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_force

	if Input.is_action_just_pressed("atk") and !is_attacking:
		is_attacking = true
		attack_timer.start()

	velocity.x = lerp(velocity.x, direction * speed, acceleration)
	update_animation(direction)
	move_and_slide()
	
func update_animation(direction):
	if is_attacking:
		sprite.play("atk1_right" if facing_right else "atk1_left")
	elif is_on_floor():
		if direction == 0:
			sprite.play("idle_right" if facing_right else "idle_left")
		else:
			sprite.play("run_right" if facing_right else "run_left")
	else:
		sprite.play("jump_right" if facing_right else "jump_left")

func _on_attack_timer_timeout():
	is_attacking = false

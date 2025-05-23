extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
var timer_started := false
var time_passed := 0.0
var reloading_started := false
var reloading_time := 0.0

func _ready() -> void:
	sprite.play("idle_right")

func _process(delta):
	if Input.is_action_just_pressed("switch_idle") and not timer_started and not reloading_started:
		sprite.play("idle-right2")
		timer_started = true
		time_passed = 0.0 
	
	if timer_started:
		time_passed += delta
		if time_passed >= 10.0:
			sprite.play("reloading")
			timer_started = false 
			reloading_started = true
			reloading_time = 0.0 
	
	if reloading_started:
		reloading_time += delta
		if reloading_time >= 15.0:
			sprite.play("idle_right")
			reloading_started = false  

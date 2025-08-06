extends CharacterBody2D

const SPEED = 100

@onready var anim_sprite = $AnimatedSprite2D
@onready var hitbox = $Hitbox

func _ready():
	anim_sprite.scale = Vector2(3, 3)
	anim_sprite.play("monster_run")
	hitbox.area_entered.connect(_on_hitbox_area_entered)

func _physics_process(delta):
	velocity.x = -SPEED
	move_and_slide()

func _on_hitbox_area_entered(area):
	if area.is_in_group("projectile"):
		print("Le monstre a été touché par :", area.name)
		queue_free()

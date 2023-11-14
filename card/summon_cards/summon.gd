extends CharacterBody2D

class_name Summon

var player_summon_id: int

# Speed Variables
@export var normal_speed: float = 80
@onready var speed: float = normal_speed

var direction: Vector2 = Vector2.ZERO


func _physics_process(delta):

	if direction != Vector2.ZERO:
		velocity = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()

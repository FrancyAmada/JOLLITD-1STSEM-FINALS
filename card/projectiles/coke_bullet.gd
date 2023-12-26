extends Node2D

@export var speed: float = 100

@onready var hit_detector: Area2D = $HitDetector

var id: int = 0

var damage: int = 0

var target
var target_direction: Vector2 = Vector2(1, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)
	if (global_position.x > 2000 or global_position.x < -500) or (global_position.y > 2700 or global_position.y < -500):
		queue_free()

func move(delta):
	if target != null:
		target_direction = (target.global_position - global_position).normalized()
	global_position += target_direction * speed * delta

func initialize(parent_id: int, parent_target, parent_damage: int):
	id = parent_id
	target = parent_target
	damage = parent_damage

func _on_hit_detector_area_entered(area):
	if area is HitBoxComponent and area.id != id:
		hit_target(area.parent)

func hit_target(target_area):
	if target_area != null:
		target_area.receive_hit(damage)
		queue_free()

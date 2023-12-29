extends Node2D

@export var speed: float = 100

@onready var hit_detector: Area2D = $HitDetector
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var damage_area: Area2D = $DamageArea

var id: int = 0

var damage: int = 0

var target
var target_direction: Vector2 = Vector2(1, 1)

func _ready():
	damage_area.monitoring = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)
	if (global_position.x > 5000 or global_position.x < -2300) or (global_position.y > 2200 or global_position.y < -800):
		queue_free()

func move(delta):
	if target != null:
		target_direction = (target.global_position - global_position).normalized()
		look_at(target.global_position)
	global_position += target_direction * speed * delta

func initialize(parent_id: int, parent_target, parent_damage: int):
	id = parent_id
	target = parent_target
	damage = parent_damage
	animation_player.play("Rotate")

func _on_hit_detector_area_entered(area):
	if area is HitBoxComponent and area.parent.summon_id != id:
		hit_target(area.parent)

func hit_target(target_area):
	if target_area != null:
		hit_detector.monitoring = false
		damage_area.monitoring = true
		animation_player.play("Explode")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Explode":
		queue_free()

func _on_damage_area_area_entered(area):
	if area is HitBoxComponent and area.parent.summon_id != id:
		area.parent.receive_hit(damage)

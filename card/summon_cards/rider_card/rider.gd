extends Summon

class_name Rider

@onready var particle: GPUParticles2D = $GPUParticles2D
@onready var attack_component: AttackComponent = $AttackComponent

@onready var target = null
@onready var max_health: float = health

var has_motor: bool = true

var gun_drawn: bool = false

func _ready():
	set_healthbar()
	set_direction()
	animation_component.connect("animation_is_finished", _on_animation_finished)
	particle.emitting = false

func _physics_process(delta):
	effects_component.process(delta)
#	print(" Value:", get_node("Sprite2D").modulate, "")
	target_detection.process(delta)
#	print(name, " ID:", summon_id, " Target:", target)
	set_target()
	set_direction()
	animation_component.update_facing_direction(direction)
	
	if (health < max_health / 2) and has_motor:
		explode()
	
	if !on_attack_range and direction != Vector2.ZERO:
		velocity = direction * speed
		
	# Character has stopped and there is an enemy
	elif on_attack_range and target != null and has_motor:
		explode()
		direction = Vector2.ZERO
		velocity = Vector2.ZERO
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()
	animation_component.update_animation(direction)
	update_healthbar()

func set_target():
	if has_motor:
		target = target_detection.get_target()
#	if target != null:
#		print_debug(target, " direction: ", direction)

func go_to_enemy_base():
	if summon_id == 1:
		direction = Vector2.RIGHT
	else:
		direction = Vector2.LEFT

func go_to_target():
	direction = (target.global_position - global_position).normalized()
	var distance: float = global_position.distance_to(target.global_position)
	if distance <= attack_range:
		on_attack_range = true

func set_direction():
	on_attack_range = false
	if target == null:
		go_to_enemy_base()
	else:
		go_to_target()

func _on_animation_finished(anim_name: String):
	if anim_name == "Death":
		queue_free()

func explode():
	normal_speed = 200
	has_motor = false
	animation_component.play("Explode")
	attack_component.explode(target_detection.targets_list)

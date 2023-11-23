extends Summon

class_name Waiter

@onready var attack_component: AttackComponent = $AttackComponent
@onready var particle: GPUParticles2D = $GPUParticles2D

@onready var target = null

func _ready():
	set_direction()
	animation_component.connect("animation_is_finished", _on_animation_finished)
	particle.emitting = false

func _physics_process(delta):
#	print(" Value:", get_node("Sprite2D").modulate, "")
	attack_component.process(delta)
	target_detection.process(delta)
#	print(name, " ID:", summon_id, " Target:", target)
	set_target()
	set_direction()

	if direction != Vector2.ZERO:
		velocity = direction * speed
		
	# Character has stopped and there is an enemy
	elif direction == Vector2.ZERO and target != null:
		attack_component.use_attack(target)
		velocity = Vector2.ZERO
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()
	animation_component.update_animation(direction)
	animation_component.update_facing_direction(direction)

func set_target():
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
	if distance <= 90:
		direction = Vector2.ZERO

func set_direction():
	if target == null:
		go_to_enemy_base()
	else:
		go_to_target()

func receive_hit(damage: float):
	self.health -= damage
	print(self, " Received Hit -- Remaining Health:", self.health)
	if self.health <= 0:
		die()
		
func die():
	is_dead = true
	animation_component.play("Death")

func _on_animation_finished(anim_name: String):
	if anim_name == "Death":
		queue_free()

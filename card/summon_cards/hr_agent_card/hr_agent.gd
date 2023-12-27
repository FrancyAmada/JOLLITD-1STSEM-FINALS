extends Summon

class_name HRAgent

var intern: PackedScene = preload("res://card/summon_cards/intern_card/intern.tscn")

@onready var attack_component: AttackComponent = $AttackComponent
@onready var particle: GPUParticles2D = $GPUParticles2D

@onready var target = null

var summon_node: Node2D

@export var summon_count: int = 2
var can_summon: bool = false
@export var summon_cd: float = 10
@onready var cd_time: float = 0
var summoning: bool = false


func _ready():
	set_healthbar()
	set_direction()
	animation_component.connect("animation_is_finished", _on_animation_finished)
	particle.emitting = false
	for child in get_node("/root").get_children():
		if child.name == "GameMap":
			summon_node = child.get_node("CardSummons")

func _physics_process(delta):
	effects_component.process(delta)
#	print(" Value:", get_node("Sprite2D").modulate, "")
	attack_component.process(delta)
	target_detection.process(delta)
#	print(name, " ID:", summon_id, " Target:", target)
	set_target()
	set_direction()
	animation_component.update_facing_direction(direction)
	
	if !can_summon:
		cd_time += delta
		if cd_time >= summon_cd:
			can_summon = true
			cd_time = 0
	elif can_summon:
		animation_component.play("Summon")
		can_summon = false
		summoning = true
	
	if !on_attack_range and direction != Vector2.ZERO and !summoning:
		velocity = direction * speed
		
	# Character has stopped and there is an enemy
	elif on_attack_range and target != null and !summoning:
		attack_component.use_attack(target)
		direction = Vector2.ZERO
		velocity = Vector2.ZERO
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()
	animation_component.update_animation(direction)
	update_healthbar()

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
	if anim_name == "Summon":
		summoning = false

func summon_interns():
	for i in range(summon_count):
		var new_intern = intern.instantiate()
		summon_node.add_child(new_intern)
		new_intern.set_summon_id(summon_id)
#		print_debug("Player ID: ", player_id, " Summon:", new_waiter)
		new_intern.global_position = global_position + Vector2(randi_range(-120, 120), randi_range(-120, 120))

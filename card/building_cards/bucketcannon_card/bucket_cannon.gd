extends Building

@onready var attack_component: AttackComponent = $AttackComponent
@onready var particle: GPUParticles2D = $TowerSmoke

@onready var target = null

func _ready():
	set_healthbar()
	animation_component.connect("animation_is_finished", _on_animation_finished)
	particle.emitting = false
	
func _physics_process(delta):
	attack_component.process(delta)
	target_detection.process(delta)
#	print(name, " ID:", summon_id, " Target:", target)
	set_target()
	if target != null:
		detect_target()
	
	if on_attack_range and target != null:
		attack_component.use_attack(target)
	
	update_healthbar()

func set_target():
	target = target_detection.get_target()

func _on_animation_finished(anim_name: String):
	if anim_name == "Death":
		queue_free()

func detect_target():
	var distance: float = global_position.distance_to(target.global_position)
	if distance <= attack_range:
		on_attack_range = true

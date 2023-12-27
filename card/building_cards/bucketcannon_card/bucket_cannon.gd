extends Building

@onready var attack_component: AttackComponent = $AttackComponent
@onready var particle: GPUParticles2D = $TowerSmoke

@onready var target = null

func _ready():
	set_healthbar()
	animation_component.connect("animation_is_finished", _on_animation_finished)
	particle.emitting = false
	
func _physics_process(delta):
	pass
	
func _on_animation_finished(anim_name: String):
	if anim_name == "Death":
		queue_free()

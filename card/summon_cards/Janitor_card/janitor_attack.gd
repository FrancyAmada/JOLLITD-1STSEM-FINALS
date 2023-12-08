extends AttackComponent

@onready var parent = get_parent()

@export var animation_component: AnimationComponent
@onready var attack_particle = $AttackParticles

@export var attack_damage: float = 10.0
@export var attack_cd: float = 1.0
var cd_time: float = 0
var can_use_attack: bool = true

var target

func _ready():
	animation_component.connect("animation_is_finished", _on_attack_animation_finished)
	animation_component.connect("facing_direction_changed", _on_changed_direction)

func process(delta):
	if !can_use_attack:
		cd_time += delta
		if cd_time >= attack_cd:
			cd_time = 0
			can_use_attack = true

func use_attack(target):
	attack_particle.process_material.direction.y = parent.direction.y * 60
	if can_use_attack and target != null and !parent.is_dead:
		animation_component.play("Attack")
		self.target = target
		can_use_attack = false
	
func _on_attack_animation_finished(anim_name: String):
	if anim_name == "Attack" and target != null:
		pass

func deal_attack():
	if target != null:
		target.receive_hit(attack_damage)
		if target is Summon:
			target.receive_effect(Effects.Effects.SLOWED, 5)

func _on_changed_direction(is_right: bool):
	if is_right:
		attack_particle.process_material.direction.x = 50
	else:
		attack_particle.process_material.direction.x = -50

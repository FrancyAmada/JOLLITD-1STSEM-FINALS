extends AttackComponent

@onready var parent = get_parent()

@export var animation_component: AnimationComponent

@export var attack_damage: float = 10.0
@export var attack_cd: float = 1.0
var cd_time: float = 0
var can_use_attack: bool = true

var target

func _ready():
	animation_component.connect("animation_is_finished", _on_attack_animation_finished)

func process(delta):
	if !can_use_attack:
		cd_time += delta
		if cd_time >= attack_cd:
			cd_time = 0
			can_use_attack = true

func use_attack(target):
	if can_use_attack and target != null and !parent.is_dead:
		animation_component.play("Attack")
		self.target = target
		can_use_attack = false
	
func _on_attack_animation_finished(anim_name: String):
	if anim_name == "Attack" and target != null:
		pass
#		target.receive_hit(attack_damage)
#		animation_component.play("Move")

func deal_attack():
	if target != null:
		target.receive_hit(attack_damage)

extends AttackComponent

@onready var parent = get_parent()

@export var animation_component: AnimationComponent
@onready var attack_particle = $AttackParticles
@onready var attack_area: Area2D = $AttackArea

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
	var direction = (target.global_position - parent.global_position).normalized()
	rotation = 2 * atan(direction.y / (direction.x + sqrt((direction.x ** 2) + (direction.y ** 2))))
	if can_use_attack and target != null and !parent.is_dead:
		animation_component.play("Attack")
		self.target = target
		can_use_attack = false
		
	
func _on_attack_animation_finished(anim_name: String):
	if anim_name == "Attack" and target != null:
		pass

func deal_attack(target_area):
	if target_area != null:
		target_area.receive_effect(Effects.Effects.SLOWED, 7)
		target_area.receive_hit(attack_damage)

func _on_attack_area_area_entered(area):
	if area is HitBoxComponent and area.id != parent.summon_id:
		deal_attack(area.parent)

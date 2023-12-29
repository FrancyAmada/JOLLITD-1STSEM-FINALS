extends AttackComponent

@onready var parent = get_parent()

@export var animation_component: AnimationComponent

@export var attack_damage: float = 300.0


func explode(targets: Array):
	for hit_box in targets:
		if hit_box.parent.summon_id != parent.summon_id:
			var distance_to_target: float = global_position.distance_to(hit_box.global_position)
			if distance_to_target <= 400:
				deal_damage(hit_box)
			
func deal_damage(hit_box: HitBoxComponent):
	if hit_box != null:
		hit_box.parent.receive_hit(attack_damage)

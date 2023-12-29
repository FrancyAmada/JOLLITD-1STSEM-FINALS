extends AttackComponent

var bullet: PackedScene = preload("res://card/projectiles/burger_bullet.tscn")

var target_detection: TargetDetectionComponent

@onready var parent = get_parent()

@export var animation_component: AnimationComponent

@export var attack_damage: float = 10.0
@export var attack_cd: float = 1.0
var cd_time: float = 0
var can_use_attack: bool = true

var target

var projectiles_node: Node2D

var place_position: Vector2 = Vector2(70, -33)

var target_distance



func _ready():
	projectiles_node = get_parent().get_parent().get_parent().get_node("Projectiles")
	animation_component.connect("animation_is_finished", _on_attack_animation_finished)
	
func process(delta):
	if !can_use_attack:
		cd_time += delta
		if cd_time >= attack_cd:
			cd_time = 0
			can_use_attack = true

func use_attack(target):
	if can_use_attack and target != null and !parent.is_dead:
		animation_component.play("Shoot")
		self.target = target
		can_use_attack = false
	
func _on_attack_animation_finished(anim_name: String):
	if anim_name == "Shoot" and target != null:
		pass
#		target.receive_hit(attack_damage)
#		animation_component.play("Move")
		
func deal_attack():
	if parent.target != null:
		var new_bullet = bullet.instantiate()
		var initial_pos = global_position + place_position
		var direction = (parent.target.global_position - global_position).normalized()
		projectiles_node.add_child(new_bullet)
		new_bullet.initialize(parent.summon_id, parent.target, attack_damage)
		new_bullet.global_position = initial_pos
		new_bullet.animation_player    


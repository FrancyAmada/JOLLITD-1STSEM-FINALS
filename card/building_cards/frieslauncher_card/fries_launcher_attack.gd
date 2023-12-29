extends AttackComponent

var bullet: PackedScene = preload("res://card/projectiles/fries_bullet.tscn")

@onready var parent = get_parent()

@export var animation_component: AnimationComponent

@export var attack_damage: float = 7.5
@export var attack_damage_2: float = 12.5
@export var last_hit_damage: float = 20.0
@export var attack_cd: float = 5.0

var cd_time: float = 0
var can_use_attack: bool = true

var target

var projectiles_node: Node2D

var place_position1: Vector2 = Vector2(45, -110)
var place_position2: Vector2 = Vector2(45, -90)
var place_position3: Vector2 = Vector2(45, -70)


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
		
func first_deal_attack():
	if parent.target != null:
		var new_bullet = bullet.instantiate()
		var initial_pos = global_position + place_position1
		var direction = (parent.target.global_position - global_position).normalized()
		projectiles_node.add_child(new_bullet)
		new_bullet.initialize(parent.summon_id, parent.target, attack_damage)
		new_bullet.global_position = initial_pos
		new_bullet.animation_player
		
func second_deal_attack():
	if parent.target != null:
		var new_bullet = bullet.instantiate()
		var initial_pos = global_position + place_position2
		var direction = (parent.target.global_position - global_position).normalized()
		projectiles_node.add_child(new_bullet)
		new_bullet.initialize(parent.summon_id, parent.target, attack_damage_2)
		new_bullet.global_position = initial_pos
		new_bullet.animation_player

func last_deal_attack():
	if parent.target != null:
		var new_bullet = bullet.instantiate()
		var initial_pos = global_position + place_position3
		var direction = (parent.target.global_position - global_position).normalized()
		projectiles_node.add_child(new_bullet)
		new_bullet.initialize(parent.summon_id, parent.target, last_hit_damage)
		new_bullet.global_position = initial_pos
		new_bullet.animation_player
		

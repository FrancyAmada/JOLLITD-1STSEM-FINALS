extends AttackComponent

var bullet: PackedScene = preload("res://card/projectiles/coke_bullet.tscn")

@onready var parent = get_parent()

@export var animation_component: AnimationComponent

@export var attack_damage: float = 10.0
@export var attack_cd: float = 1.0
var cd_time: float = 0
var can_use_attack: bool = true

var projectiles_node: Node2D

var place_position: Vector2 = Vector2(90, -34)

var target

func _ready():
	projectiles_node = get_parent().get_parent().get_parent().get_node("Projectiles")
	animation_component.connect("animation_is_finished", _on_attack_animation_finished)
	animation_component.connect("facing_direction_changed", _on_direction_changed)

func process(delta):
	if !can_use_attack:
		cd_time += delta
		if cd_time >= attack_cd:
			cd_time = 0
			can_use_attack = true

func use_attack(target):
	if can_use_attack and target != null and !parent.is_dead:
		if parent.gun_drawn and target != null:
			animation_component.play("Attack_Shoot")
			self.target = target
			can_use_attack = false
		if !parent.gun_drawn and target != null:
			animation_component.play("Attack_Draw")
		
	
func _on_attack_animation_finished(anim_name: String):
	if anim_name == "Attack_Draw":
		parent.gun_drawn = true

func _on_direction_changed(is_right: bool):
	if is_right:
		place_position = Vector2(90, -34)
	else:
		place_position = Vector2(-90, -34)

func deal_attack():
	var new_bullet = bullet.instantiate()
	projectiles_node.add_child(new_bullet)
	new_bullet.initialize(parent.summon_id, parent.target, attack_damage)
	new_bullet.global_position = global_position + place_position

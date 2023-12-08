extends CharacterBody2D

class_name Summon

var summon_id: int = 0

@onready var animation_component: AnimationComponent = $AnimationComponent
@onready var target_detection: TargetDetectionComponent = $TargetDetection
@onready var hitbox_component: HitBoxComponent = $HitBox
@onready var healthbar: ProgressBar = $HealthBar
@onready var effects_component: EffectsComponent = $EffectsComponent

# Speed Variables
@export var normal_speed: float = 80
@onready var speed: float = normal_speed

# Health Variables
@export var health: float = 100
var is_dead: bool = false

@export var attack_range: int = 90
var on_attack_range: bool = false

var direction: Vector2 = Vector2.ZERO

func set_summon_id(id: int):
	summon_id = id
	hitbox_component.id = id
	set_healthbar()
	
func receive_hit(damage: float):
	self.health -= damage
#	print(self, " Received Hit -- Remaining Health:", self.health)
	if self.health <= 0:
		healthbar.visible = false
		die()
		
func receive_effect(effect, effect_time: float):
	effects_component.add_effect(effect, effect_time)

func die():
	is_dead = true
	animation_component.play("Death")

func update_healthbar():
	healthbar.value = self.health

func set_healthbar():
	healthbar.max_value = self.health
	if summon_id != 0:
		healthbar.modulate.r = 0
		healthbar.modulate.b = 1

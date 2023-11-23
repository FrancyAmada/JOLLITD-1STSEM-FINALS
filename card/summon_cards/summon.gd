extends CharacterBody2D

class_name Summon

var summon_id: int = 0

@onready var animation_component: AnimationComponent = $AnimationComponent
@onready var target_detection: TargetDetectionComponent = $TargetDetection
@onready var hitbox_component: HitBoxComponent = $HitBox

# Speed Variables
@export var normal_speed: float = 80
@onready var speed: float = normal_speed

@export var health: float = 100
var is_dead: bool = false

var direction: Vector2 = Vector2.ZERO

func set_summon_id(id: int):
	summon_id = id
	hitbox_component.id = id
	

extends Node2D

class_name EffectsComponent

@onready var slowed_particle: GPUParticles2D = $SlowedEffect

@onready var parent: Summon = get_parent()

var effects: Array

func _ready():
	slowed_particle.emitting = false
	
func process(delta):
	reset_effects()
	for effect in effects:
		match effect[0]:
			Effects.Effects.SLOWED:
				parent.speed = parent.normal_speed * 0.5
				slowed_particle.emitting = true
		
		effect[1] -= delta
		if effect[1] <= 0:
			effects.erase(effect)
			
func reset_effects():
	parent.speed = parent.normal_speed
	slowed_particle.emitting = false

func add_effect(effect, effect_time: float):
	effects.append([effect, effect_time])
	
func has_effect(target_effect):
	for effect in effects:
		if effect[0] == target_effect:
			return true
	return false

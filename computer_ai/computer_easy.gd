extends Node2D

class_name EasyAI

@export var health: int = 300

@onready var player_id: int = 0


func _on_area_2d_area_entered(area):
	if area is HitBoxComponent and area.parent.summon_id != player_id:
		self.health -= area.parent.attack_component.base_damage
#		print(self.health)

func _on_area_2d_area_exited(area):
	if area is HitBoxComponent and area.parent.summon_id != player_id:
		area.parent.queue_free()

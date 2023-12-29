extends Area2D

class_name TargetDetectionComponent

@onready var parent = get_parent()

var nearest_target
var nearest_distance: float = 1000

var targets_list: Array

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta):
	get_nearest_target()
	
func get_nearest_target():
#	print_debug(targets_list, " by ", parent)
	nearest_target = null
	nearest_distance = 2000
	for hit_box in targets_list:
		var distance: float = global_position.distance_to(hit_box.global_position)
		if distance < nearest_distance and int(hit_box.id) != int(parent.summon_id):
			nearest_distance = distance
			nearest_target = hit_box
	
func get_target():
	if nearest_target != null:
		return nearest_target.get_parent()
	return null

func _on_area_entered(area):
	if area.is_in_group("hit_box") and area != parent.hitbox_component:
#		print_debug(parent, " summon id:",  parent.summon_id, " --- Target id:", area.id)
		targets_list.append(area)
#		print_debug(area.name, " - detected by ", parent, " ID: ", parent.summon_id)

func _on_area_exited(area):
	if area in targets_list:
		targets_list.erase(area)

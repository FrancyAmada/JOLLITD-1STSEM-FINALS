extends Node2D

var clouds_list: Array

@export var cloud_speed: float = 150

@onready var parallax_bg: ParallaxBackground = $ParallaxBackground


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is Sprite2D:
			clouds_list.append(child)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	for cloud in clouds_list:
		cloud.global_position.x -= cloud_speed * delta
		if cloud.global_position.x <= -301:
			cloud.global_position.x = get_rightmost_position(cloud)
	parallax_bg.scroll_offset.x -= cloud_speed * delta

func get_rightmost_position(cloud):
	var rightmost_position = 0
	for cloud_to_check in clouds_list:
		if cloud_to_check != cloud and cloud_to_check.global_position.x >= rightmost_position:
			rightmost_position = cloud_to_check.global_position.x
	return rightmost_position + 573

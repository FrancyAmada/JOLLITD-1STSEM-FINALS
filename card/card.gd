extends Area2D

class_name Card

@onready var summon_node: Node2D = get_node("/root/GameMap/CardSummons")

var in_placement_area: bool = false
var in_valid_area: bool = false
var is_grabbed: bool = false

var initial_position: Vector2

func _ready():
	set_initial_position()

func set_initial_position():
	initial_position = Vector2(global_position.x, global_position.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func place(place_position: Vector2):
	pass

func grab():
	is_grabbed = true
	
func un_grab():
	is_grabbed = false

func return_to_position():
	global_position = initial_position
	in_valid_area = false
	in_placement_area = false

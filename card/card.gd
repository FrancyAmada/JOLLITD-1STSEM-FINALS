extends Area2D

class_name Card

@export var cost: int = 0

var player_id: int

@onready var summon_node: Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var can_grab: bool = false
var in_placement_area: bool = false
var in_valid_area: bool = false
var is_grabbed: bool = false

var bag_position: Vector2 = Vector2(1075, 575)
var from_bag: bool = true
var initial_position: Vector2

func _ready():
	animation_player.connect("animation_finished", _on_animation_player_animation_finished)
	for child in get_node("/root").get_children():
		if child.name == "GameMap":
			summon_node = child.get_node("CardSummons")
	animation_player.play("get_from_bag")

func set_initial_position():
	initial_position = Vector2(global_position.x, global_position.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta):
	if from_bag:
		global_position = global_position.move_toward(initial_position, 50)
	if global_position == initial_position:
		from_bag = false
		

func place(place_position: Vector2):
	pass

func grab():
	if can_grab:
		is_grabbed = true
		animation_player.play("grab")
	
func un_grab():
	if can_grab:
		is_grabbed = false
		animation_player.play("un_grab")

func return_to_position():
	global_position = initial_position
	in_valid_area = false
	in_placement_area = false

func set_id(id: int):
	player_id = id

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "get_from_bag":
		can_grab = true

func place_auto(place_position:Vector2):
	summon(place_position)
	queue_free()
	
func summon(place_position:Vector2):
	pass
	

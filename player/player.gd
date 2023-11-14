extends Node2D

class_name Player

@onready var player_ui: PlayerUI = $PlayerUI
@onready var current_cards: Node = player_ui.get_node("Cards")
@onready var mouse: Area2D = $Mouse

var cards_list: Array[Card]

@export var speed: float = 10.0

var direction: Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	direction = Input.get_vector("left", "right", "up", "down")
	
	if check_on_boundary():
		self.global_position += direction * speed
		
func _process(delta):
	mouse.global_position = get_global_mouse_position()

func check_on_boundary():
	var new_position = self.global_position + (direction * speed)
	return (-104 <new_position.y and new_position.y < 766) and (
		-81 < new_position.x and new_position.x < 1000)

func get_mouse_position():
	return Vector2(mouse.global_position.x, mouse.global_position.y)


func _on_mouse_area_entered(area):
	if area.is_in_group("game_area"):
		player_ui.mouse_is_in_game_area = true

func _on_mouse_area_exited(area):
	if area.is_in_group("game_area"):
		player_ui.mouse_is_in_game_area = false

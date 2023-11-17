extends Node2D

class_name Player

@onready var profile: Profile = $Profile
@onready var player_ui: PlayerUI = $PlayerUI
@onready var current_cards: Node = player_ui.get_node("Cards")
@onready var mouse: Area2D = $Mouse

# Cards Deck
var deck: Array
# current cards
var cards: Array

@export var speed: float = 10.0

var direction: Vector2 = Vector2.ZERO


## Called when the node enters the scene tree for the first time.
#func _ready():
#	get_cards()
#	print_debug(cards)

func _physics_process(delta):
	direction = Input.get_vector("left", "right", "up", "down")
	
	if check_on_boundary():
		self.global_position += direction * speed
		
func _process(delta):
	mouse.global_position = get_global_mouse_position()
	player_ui.process(delta)

func _input(event):
	player_ui.input(event)

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

func get_cards_from_deck():
	for card in deck:
		cards.append(card)
		cards.append(card)

func get_card():
	if cards.size() == 0:
		get_cards_from_deck()
		
	var card = cards.pop_front()
	player_ui.add_card(card)
	
func load_player():
	deck = profile.deck
	get_cards_from_deck()
	for i in range(5):
		get_card()
	

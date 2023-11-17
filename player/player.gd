extends Node2D

class_name Player

# Camera Variables
@export var speed: float = 10.0
var direction: Vector2 = Vector2.ZERO

@onready var profile: Profile = $Profile
@onready var player_ui: PlayerUI = $PlayerUI
@onready var current_cards: Node = player_ui.get_node("Cards")
@onready var mouse: Area2D = $Mouse

# Cards Deck
var deck: Array
# current cards
var cards: Array

var placed_card: bool = false
var card_timer: float = 0.0
var card_cooldown: float = 2.5

## Called when the node enters the scene tree for the first time.
#func _ready():
#	get_cards()
#	print_debug(cards)

func _physics_process(delta):
	direction = Input.get_vector("left", "right", "up", "down")
	
	if check_on_boundary():
		self.global_position += direction * speed
		
	if placed_card:
		card_timer += delta
		if card_timer >= card_cooldown:
			get_card()
			card_timer = 0.0
			placed_card = false
			
	elif player_ui.cards_node.get_child_count() < 5:
		card_timer += delta
		if card_timer >= card_cooldown:
			get_card()
			card_timer = 0.0
			print(player_ui.cards_node.get_child_count())
		
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
	

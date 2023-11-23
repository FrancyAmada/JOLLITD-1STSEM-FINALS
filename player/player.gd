extends Node2D

class_name Player

@onready var player_id: int = 1

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

# Bone production per second
var bones_production: float = 2
var bones_float: float = 0.0
var bones: int = 4

var time_count: float = 0.0

## Called when the node enters the scene tree for the first time.
func _ready():
#	get_cards()
#	print_debug(cards)
	player_ui.set_bones_label(bones)

func _physics_process(delta):
	direction = Input.get_vector("left", "right", "up", "down")
	
	if check_on_boundary():
		self.global_position += direction * speed
		
	# Check if player just placed a card
	if placed_card:
		card_timer += delta
		if card_timer >= card_cooldown:
			get_card()
			card_timer = 0.0
			placed_card = false
	
	# Check if player has less than 5 cards
	elif player_ui.cards_node.get_child_count() < 5:
		card_timer += delta
		if card_timer >= card_cooldown:
			get_card()
			card_timer = 0.0
			print(player_ui.cards_node.get_child_count())
	
	# Bone Production
	if time_count >= 1:
		time_count = 0
		bones_float += bones_production
		if bones_float >= 1.0 and bones < 30:
			if bones + floor(bones_float) > 30:
				bones = 30
			else:
				bones += floor(bones_float)
			bones_float -= floor(bones_float)
			
	time_count += delta
	
func _process(delta):
	mouse.global_position = get_global_mouse_position()
	player_ui.process(delta)
	player_ui.set_bones_label(bones)
	player_ui.set_deck_label(cards.size())

func _input(event):
	player_ui.input(event)

func check_on_boundary():
	# check if camera is inside the boundary
	var new_position = self.global_position + (direction * speed)
	return (20 < new_position.y and new_position.y < 560) and (138 < new_position.x and new_position.x < 788)

func get_mouse_position():
	return Vector2(mouse.global_position.x, mouse.global_position.y)


func _on_mouse_area_entered(area):
	if area.is_in_group("game_area"):
		player_ui.mouse_is_in_game_area = true
	if area.is_in_group("player_area"):
		player_ui.mouse_is_in_player_area = true

func _on_mouse_area_exited(area):
	if area.is_in_group("game_area"):
		player_ui.mouse_is_in_game_area = false
	if area.is_in_group("player_area"):
		player_ui.mouse_is_in_player_area = false

func get_cards_from_deck():
	for card in deck:
		cards.append(card)
		cards.append(card)
	randomize()
	cards.shuffle()

func get_card():
	var card = cards.pop_front()
	player_ui.add_card(card)
	
	if cards.size() == 0:
		get_cards_from_deck()
	
func load_player():
	deck = profile.deck
	get_cards_from_deck()
	for i in range(5):
		get_card()
	

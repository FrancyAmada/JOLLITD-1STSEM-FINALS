extends Node2D

class_name EasyAI

@export var health: int = 300

@onready var player_id: int = 0

@onready var current_cards: Node = get_node("Cards")

@onready var player1: Player = get_parent().get_node("Player1")

@onready var deck: Array = [Global.available_cards[0], Global.available_cards[1],
	Global.available_cards[2], Global.available_cards[3], Global.available_cards[4],
	Global.available_cards[5], Global.available_cards[6], Global.available_cards[7]]
# current cards
var cards: Array

var placed_card: bool = false
var card_timer: float = 0.0
var card_cooldown: float = 2.5

# Bone production per second
var bones_production: float = 1
var bones_float: float = 0.0
var bones: int = 5

var time_count: float = 0.0

var updated: bool = false

var paused: bool = false


func _ready():
	get_cards_from_deck()

func _physics_process(delta):
	paused = player1.player_ui.paused
	
	if placed_card:
		card_timer += delta
		if card_timer >= card_cooldown:
			card_timer = 0.0
			placed_card = false
	
	# Check if player has less than 5 cards
	elif current_cards.get_child_count() < 5:
		card_timer += delta
		if card_timer >= card_cooldown:
			card_timer = 0.0
			print(current_cards.get_child_count())
	
	# Bone Production
	if time_count >= 1 and !paused:
		time_count = 0
		bones_float += bones_production
		if bones_float >= 1.0 and bones < 30:
			if bones + floor(bones_float) > 30:
				bones = 30
			else:
				bones += floor(bones_float)
			bones_float -= floor(bones_float)
		
		var choice_to_place: int = randi_range(-1, 1)
		if choice_to_place > 0:
			place_card(get_card())
		
	time_count += delta
	print(bones)


func get_cards_from_deck():
	for card in deck:
		cards.append(card)
		cards.append(card)
	randomize()
	cards.shuffle()

func get_card():
	var card = cards.pop_front()
	
	if cards.size() == 0:
		get_cards_from_deck()
		
	return card

func _on_area_2d_area_entered(area):
	if area is HitBoxComponent and area.parent.summon_id != player_id:
		self.health -= area.parent.attack_component.base_damage
#		print(self.health)

func _on_area_2d_area_exited(area):
	if area is HitBoxComponent and area.parent.summon_id != player_id:
		area.parent.queue_free()

func place_card(card):
	var place_position: Vector2 = Vector2(randi_range(2700, 3500), randi_range(50, 1250))
	var card_instance = card.instantiate()
	current_cards.add_child(card_instance)
	card_instance.set_id(player_id)
	if card_instance.cost <= bones:
		bones -= card_instance.cost
		card_instance.place_auto(place_position)
	else:
		card_instance.queue_free()
	placed_card = true
	

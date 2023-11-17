extends CanvasLayer

class_name PlayerUI

@onready var player: Player = get_parent()
@onready var cards_node: Node = get_node("Cards")
@onready var mouse_area: Area2D = $Mouse
var mouse_position: Vector2 = Vector2.ZERO
var mouse_is_in_game_area: bool = false

var is_on_card: Card = null
var grabbed_card: Card = null

# Called when the node enters the scene tree for the first time.
#func _ready():
#	for card in cards_node.get_children():
#		if card is Card:
#			card.set_initial_position()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta):
	set_mouse_position()
	
	if grabbed_card != null:
		grabbed_card.in_valid_area = mouse_is_in_game_area
		grabbed_card.global_position = mouse_position
	
#	print_debug("Mouse Position: ", player.get_mouse_position(), " In Game Area: ", mouse_is_in_game_area)
	
func add_card(card):
	var card_instance = card.instantiate()
	cards_node.add_child(card_instance)
	set_cards_positions()
	
func set_cards_positions():
	var max_posx = 300
	var cards_amount = cards_node.get_child_count()
	var center = player.get_viewport_rect().size / 2
	var spacing = max_posx / cards_amount
	var i = 0
	for card in cards_node.get_children():
		var card_position = Vector2((center.x + ((cards_amount-1) * spacing)/2) - (i * spacing), 570)
		i += 1
		card.initial_position = card_position
		card.position = card_position
	
func input(event):
	if event is InputEventMouseButton:
#		print_debug("Mouse is at position: ", event.position)
		if is_on_card != null:
			grabbed_card = is_on_card
			is_on_card = null
			grabbed_card.grab()
		elif grabbed_card != null:
			grabbed_card.place(player.get_mouse_position())
			grabbed_card = null
			
	if event is InputEventMouseMotion:
#		print_debug("Mouse is at position: ", event.position)
		mouse_position = event.position

func _on_mouse_area_entered(area):
	if area is Card:
		is_on_card = area
#		print_debug(is_on_card)
		
func _on_mouse_area_exited(area):
	if area == is_on_card:
		is_on_card = null

func set_mouse_position():
	mouse_area.global_position = mouse_position

func _on_place_area_area_entered(area):
	if area.is_in_group("mouse"):
		if grabbed_card != null:
			grabbed_card.in_placement_area = true

func _on_place_area_area_exited(area):
	if area.is_in_group("mouse"):
		if grabbed_card != null:
			grabbed_card.in_placement_area = false

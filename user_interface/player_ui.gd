extends CanvasLayer

class_name PlayerUI

@onready var player: Player = get_parent()
@onready var cards_node: Node = get_node("Cards")
@onready var bones_label: Label = $BonesLabel

# Mouse variables
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
	cards_process(delta)
	set_mouse_position()
	set_cards_positions()
	
	if grabbed_card != null:
		grabbed_card.in_valid_area = mouse_is_in_game_area
		grabbed_card.global_position = mouse_position
	
#	print_debug("Mouse Position: ", player.get_mouse_position(), " In Game Area: ", mouse_is_in_game_area)
	
func add_card(card):
	var card_instance = card.instantiate()
	cards_node.add_child(card_instance)
	set_cards_positions()
	card_instance.global_position = card_instance.bag_position
	
func set_cards_positions():
	var spacing: float
	var max_posx = 450
	var cards_amount = cards_node.get_child_count()
	var center = player.get_viewport_rect().size / 2
	if cards_amount != 0:
		spacing = max_posx / cards_amount
	else:
		spacing = max_posx
	var i = 0
	for card in cards_node.get_children():
		var card_position = Vector2((center.x + ((cards_amount-1) * spacing)/2) - (i * spacing), 570)
		i += 1
		card.initial_position = card_position
#		card.position = card_position
		if !card.from_bag and grabbed_card != card:
			card.return_to_position()
	
func input(event):
	if event is InputEventMouseButton:
#		print_debug("Mouse is at position: ", event.position)
		if is_on_card != null and !is_on_card.from_bag:
			un_grab_cards()
			grabbed_card = is_on_card
			is_on_card = null
			grabbed_card.grab()
			mouse_area.monitoring = false
		elif grabbed_card != null:
			if grabbed_card.cost <= player.bones:
				player.bones -= grabbed_card.cost
				grabbed_card.place(player.get_mouse_position())
			un_grab_cards()
			grabbed_card = null
			mouse_area.monitoring = true
			
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

func cards_process(delta: float):
	for card in cards_node.get_children():
		if card.from_bag:
			card.process(delta)
			
func un_grab_cards():
	for card in cards_node.get_children():
		card.un_grab()

func set_bones_label(amount: int):
	bones_label.text = str(amount)
	

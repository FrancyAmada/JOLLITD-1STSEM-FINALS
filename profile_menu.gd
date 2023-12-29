extends Node

var profile

var profile_name: String = "Player"
var profile_deck: Array[int] = []


@onready var main_menu = "res://main_menu.tscn"

@onready var deck_list: ItemList = get_node("ProfileGUI/Panel/DeckCards")
@onready var available_list: ItemList = get_node("ProfileGUI/Panel/AvailableCards")

@onready var profile_name_label: Label = get_node("ProfileGUI/Panel/ProfileName")
@onready var name_edit: TextEdit = get_node("ProfileGUI/Panel/NameEdit")
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D


var changing_card: bool = false
var deck_index_selected: int = 0
var available_index_selected: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	profile = Global.player_profile
	profile_name = profile["profile"]["name"]
	profile_deck = load_profile_deck()
	set_profile_name_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_available_cards_item_selected(index):
	print("Card index selected: ",index)
	if index not in profile_deck and changing_card:
		profile_deck[deck_index_selected] = index
		deck_list.set_item_icon(deck_index_selected, available_list.get_item_icon(index))
		deck_list.set_item_text(deck_index_selected, available_list.get_item_text(index))
		available_list.deselect_all()
		deck_list.deselect_all()
		print_debug("Card changed")
	else:
		available_list.deselect(index)
		changing_card = false
		print_debug("Card already in deck")
	

func _on_button_pressed():
	# go to main menu
	Global.save_profile(profile_name_label.text, profile_deck)
	get_tree().change_scene_to_file(main_menu)

func _on_deck_cards_item_selected(index):
	if deck_list.is_selected(index) and changing_card:
		changing_card = false
		available_list.deselect_all()
		deck_list.deselect_all()
	else:
		changing_card = true
		deck_index_selected = index
		print("Changing Card at index: ", index)

func load_profile_deck():
	var loaded_deck: Array[int]
	var current_index: int = 0
	for card_index in profile["deck"]:
		var index = int(card_index)
		loaded_deck.append(index)
		deck_list.set_item_icon(current_index, available_list.get_item_icon(index))
		deck_list.set_item_text(current_index, available_list.get_item_text(index))
		current_index += 1
		
	print(loaded_deck)
	return loaded_deck


func _on_text_edit_text_set():
	profile_name_label.text = name_edit.text

func _on_name_edit_text_changed():
	if len(name_edit.text) <= 12:
		profile_name_label.text = name_edit.text

func set_profile_name_label():
	profile_name_label.text = profile_name


func _on_audio_stream_player_2d_finished():
	audio_player.play(0)
	audio_player.playing = true

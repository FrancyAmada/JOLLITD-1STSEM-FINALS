extends Node

var profile

var profile_name: String = "Player"
var profile_deck: Array[int] = []

@onready var save_path = "res://user_profile/saveFileProfile.save"

@onready var main_menu = "res://main_menu.tscn"

@onready var deck_list: ItemList = get_node("ProfileGUI/Panel/DeckCards")
@onready var available_list: ItemList = get_node("ProfileGUI/Panel/AvailableCards")

@onready var profile_name_label: Label = get_node("ProfileGUI/Panel/ProfileName")
@onready var name_edit: TextEdit = get_node("ProfileGUI/Panel/NameEdit")

var changing_card: bool = false
var deck_index_selected: int = 0
var available_index_selected: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	profile = load_profile()
	profile_name = profile["profile"]["name"]
	profile_deck = load_profile_deck()
	set_profile_name_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_available_cards_item_activated(index):
	print("Card index selected: ",index)
	if index not in profile_deck and changing_card:
		profile_deck[deck_index_selected] = index
		deck_list.set_item_icon(deck_index_selected, available_list.get_item_icon(index))
		deck_list.set_item_text(deck_index_selected, available_list.get_item_text(index))
		print_debug("Card changed")
	else:
		print_debug("Card already in deck")
	
func load_profile():
	if !FileAccess.file_exists(save_path):
		print("Error, no Save File to load.")
		return null
	
	var save_file = FileAccess.open(save_path, FileAccess.READ)
	
	while save_file.get_position() < save_file.get_length():
		# Get the saved dictionary from the next line in the save file
		var json = JSON.new()
		json.parse(save_file.get_line())
		
		var loaded_data = json.get_data()
		print_debug("Loaded Data: ", loaded_data)
		
		save_file.close()
		return loaded_data

func save_profile():
	var save_file = FileAccess.open(save_path, FileAccess.WRITE) # Open File
	var profile_name = profile_name_label.text
	var profile_data: Dictionary = {
		"profile": {
			"name": profile_name,
			},
		"deck": profile_deck
	}
	
	# Store the save dictionary as a new line in the save file.
	save_file.store_line(JSON.stringify(profile_data))
	
	save_file.close() # Close File
	print_debug("Saved game: Data - ", JSON.stringify(profile_data))

func _on_button_pressed():
	# go to main menu
	save_profile()
	get_tree().change_scene_to_file(main_menu)


func _on_deck_cards_item_activated(index):
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
	profile_name_label.text = name_edit.text

func set_profile_name_label():
	profile_name_label.text = profile_name

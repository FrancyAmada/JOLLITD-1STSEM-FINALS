extends Node

signal saved_game()

# Cards List 
@onready var available_cards: Array = [
	# Summons
	preload("res://card/summon_cards/intern_card/intern_card.tscn"),
	preload("res://card/summon_cards/waiter_card/waiter_card.tscn"),
	preload("res://card/summon_cards/janitor_card/janitor_card.tscn"),
	preload("res://card/summon_cards/manager_card/manager_card.tscn"),
	preload("res://card/summon_cards/chef_card/chef_card.tscn"),
	preload("res://card/summon_cards/security_card/security_card.tscn"),
	preload("res://card/summon_cards/hr_agent_card/hr_agent_card.tscn"),
	preload("res://card/summon_cards/rider_card/rider_card.tscn"),
	
	# Towers
	preload("res://card/building_cards/bucketcannon_card/bucket_cannon_card.tscn"),
	preload("res://card/building_cards/burgercannon_card/burger_cannon_card.tscn"),
	preload("res://card/building_cards/cokesprayer_card/coke_sprayer_card.tscn"),
	preload("res://card/building_cards/frieslauncher_card/fries_launcher_card.tscn"),
	preload("res://card/building_cards/hotdoglauncher_card/hotdog_launcher_card.tscn")
]

@onready var player_profile = load_profile()

var save_path = "res://user_profile/saveFileProfile.save"


func load_profile():
	if !FileAccess.file_exists(save_path):
		print("Error, no Save File to load.")
		var new_profile = create_new_profile()
		save_profile(new_profile["profile"]["name"], new_profile["deck"])
		return new_profile
	
	var save_file = FileAccess.open(save_path, FileAccess.READ)
	
	while save_file.get_position() < save_file.get_length():
		# Get the saved dictionary from the next line in the save file
		var json = JSON.new()
		json.parse(save_file.get_line())
		
		var loaded_data = json.get_data()
		print_debug("Loaded Data: ", loaded_data)
		
		save_file.close()
		return loaded_data
	
	
func save_profile(profile_name: String, profile_deck: Array):
	var save_file = FileAccess.open(save_path, FileAccess.WRITE) # Open File
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
	
	player_profile = load_profile()
	saved_game.emit()
	
func create_new_profile():
	var beginner_deck: Array = [0, 1, 2, 3, 4, 5, 6, 7]
	var profile_name = "Player"
	var dict := {
		"profile": {
			"name": profile_name,
			},
		"deck": beginner_deck
	}
	return dict

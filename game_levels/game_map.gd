extends Node2D

@onready var player1: Player = get_node("Player1")
var player1_profile

func _ready():
	player1_profile = get_player1_profile()
	if player1_profile != null:
		set_player(player1, player1_profile)
	else:
		player1_profile = create_new_profile()
		set_player(player1, player1_profile)
	print_debug(player1.profile.saveObject())
	
func set_player(player: Player, player_profile: Dictionary):
	player.profile.set_profile(player_profile)
	player.load_player()
	
func save_game():
	var save_file = FileAccess.open("saveFileProfile", FileAccess.WRITE) # Open File
	
	var profile_node = player1.get_node("Profile")
	var profile_data = profile_node.saveObject()
	
	# Store the save dictionary as a new line in the save file.
	save_file.store_line(JSON.stringify(profile_data))
	
	save_file.close() # Close File

func get_player1_profile():
	if !FileAccess.file_exists("user_profile/saveFileProfile"):
		print("Error, no Save File to load.")
		return null
	
	var save_file = FileAccess.open("saveFileProfile", FileAccess.READ)
	
	while save_file.get_position() < save_file.get_length():
		# Get the saved dictionary from the next line in the save file
		var json = JSON.new()
		json.parse(save_file.get_line())
		
		var loaded_data = json.get_data()
		
		save_file.close()
		return loaded_data

func create_new_profile():
	var beginner_deck: Array = [Global.available_cards[0]]
	var profile_name = "Administrator"
	var dict := {
		"profile": {
			"name": profile_name,
			},
		"deck": beginner_deck
	}
	return dict

extends Node2D

@onready var save_path = "res://user_profile/saveFileProfile.save"

@onready var main_menu = "res://main_menu.tscn"

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready var player1: Player = $Player1
var player1_profile = null

@export var boundary: Array[int] = [0, 0, 0, 0]

@onready var player2: EasyAI = $Player2
var player2_profile = null


func _ready():
	self.name = "GameMap"
	player1_profile = get_player1_profile()
	if player1_profile != null:
		set_player(player1, player1_profile)
	else:
		player1_profile = create_new_profile()
		set_player(player1, player1_profile)
	print_debug(player1.profile.saveObject())
	player1.player_ui.animation_player.connect("animation_finished", _on_animation_finished)
	audio_player.playing = true
	save_game()
	
func set_player(player: Player, player_profile: Dictionary):
	player.profile.set_profile(player_profile)
	player.load_player()
	
func save_game():
	var save_file = FileAccess.open(save_path, FileAccess.WRITE) # Open File
	
	var profile_node = player1.get_node("Profile")
	var profile_data = profile_node.saveObject()
	
	# Store the save dictionary as a new line in the save file.
	save_file.store_line(JSON.stringify(profile_data))
	
	save_file.close() # Close File
	print_debug("Saved game: Data - ", JSON.stringify(profile_data))

func get_player1_profile():
	if !FileAccess.file_exists(save_path):
		print("Error, no Save File to load.")
		return null
	
	var save_file = FileAccess.open(save_path, FileAccess.READ)
	
	while save_file.get_position() < save_file.get_length():
		# Get the saved dictionary from the next line in the save file
		var json = JSON.new()
		json.parse(save_file.get_line())
		
		var loaded_data = json.get_data()
		
		save_file.close()
		return loaded_data

func create_new_profile():
	var beginner_deck: Array = [0, 1, 2, 3, 4, 5, 6, 7]
	var profile_name = "Administrator"
	var dict := {
		"profile": {
			"name": profile_name,
			},
		"deck": beginner_deck
	}
	return dict

func _process(delta):
	if player1.health <= 0:
		player1.player_ui.animation_player.play("game_over")
	if player2.health <= 0:
		player1.player_ui.animation_player.play("winner")

func return_to_menu():
	get_tree().change_scene_to_file(main_menu)

func _on_animation_finished(anim_name):
	if anim_name == "game_over" or anim_name == "winner":
		return_to_menu()

func _on_audio_stream_player_2d_finished():
	audio_player.play()

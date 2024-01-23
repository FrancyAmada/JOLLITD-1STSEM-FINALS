extends Node

var game_map = "res://game_levels/city_map.tscn"

var profile_menu = "res://profile_menu.tscn"

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var title_anim_player: AnimationPlayer = get_node("Label/AnimationPlayer")
@onready var sfx_button = get_node("GUIControl/Panel/HBoxContainer/SFXButton")

@onready var mouse_in = false


func _ready():
	audio_player.playing = Global.sound_on
	title_anim_player.play("display")
	sfx_button.button_pressed = Global.sound_on

func _physics_process(delta):
	pass
	
func _input(event):
	if Input.is_action_pressed("Left_click") and mouse_in:
		get_tree().change_scene_to_file(game_map)

func _on_area_2d_2_mouse_entered():
	mouse_in = true
	get_node('Area2D2/CollisionShape2D/AnimationPlayer').play("hovered")
	

func _on_area_2d_2_mouse_exited():
	mouse_in = false
	get_node("Area2D2/CollisionShape2D/AnimationPlayer").play('retract')


func _on_video_stream_player_finished():
	get_node('Area2D/CollisionShape2D/VideoStreamPlayer').play()
	

func _on_button_pressed():
	get_tree().change_scene_to_file(game_map)


func _on_audio_stream_player_2d_finished():
	audio_player.play(0)


func _on_sfx_button_toggled(button_pressed):
	audio_player.playing = button_pressed
	Global.sound_on = button_pressed
	
func _on_profile_button_pressed():
	get_tree().change_scene_to_file(profile_menu)


func _on_exit_button_pressed():
	get_tree().quit()

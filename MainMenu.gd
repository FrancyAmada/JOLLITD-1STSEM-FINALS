extends Node2D

var game_map = "res://game_levels/city_map.tscn"

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready():
	pass

func _physics_process(delta):
	pass
	

#func _on_button_pressed():
	#get_tree().change_scene_to_file(game_map)


@onready var mouse_in = false

func _on_area_2d_2_mouse_entered():
	mouse_in = true
	get_node('Area2D2/CollisionShape2D/AnimationPlayer').play("hovered")
	

func _on_area_2d_2_mouse_exited():
	mouse_in = false
	get_node("Area2D2/CollisionShape2D/AnimationPlayer").play('retract')

func _on_area_2d_2_input_event(viewport, event, shape_idx):
	if Input.is_action_just_pressed("Left_click"):
		get_tree().change_scene_to_file(game_map)


func _on_video_stream_player_finished():
	get_node('Area2D/CollisionShape2D/VideoStreamPlayer').play()
	

func _on_button_pressed():
	get_tree().change_scene_to_file(game_map)


func _on_audio_stream_player_2d_finished():
	audio_player.play(0)

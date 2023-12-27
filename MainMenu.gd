extends Node2D

var game_map = "res://game_levels/city_map.tscn"

func _ready():
	pass

func _on_button_pressed():
	get_tree().change_scene_to_file(game_map)

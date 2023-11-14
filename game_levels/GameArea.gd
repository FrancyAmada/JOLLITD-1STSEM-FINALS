extends Area2D


func _on_area_entered(area):
	if area.is_in_group("mouse"): pass
#		area.get_parent().mouse_is_in_game_area = true
#		print_debug("Mouse is inside game area")

func _on_area_exited(area):
	if area.is_in_group("mouse"): pass
#		area.get_parent().mouse_is_in_game_area = false
#		print_debug("Mouse is outside game area")

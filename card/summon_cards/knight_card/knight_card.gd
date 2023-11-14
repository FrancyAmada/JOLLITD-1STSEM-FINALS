extends Card


func place(place_position: Vector2):
	if is_grabbed and in_valid_area and in_placement_area:
		print_debug("Placed at: ", place_position)
		queue_free()
	else:
		un_grab()
		return_to_position()

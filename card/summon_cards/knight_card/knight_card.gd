extends Card


var jollibee_knight_crew: PackedScene = preload("res://card/summon_cards/knight_card/jollibee_knight_crew.tscn")

func place(place_position: Vector2):
	if is_grabbed and in_valid_area and in_placement_area:
		get_parent().get_parent().player.placed_card = true
		print_debug("Placed at: ", place_position)
		summon(place_position)
		queue_free()
	else:
		un_grab()
		return_to_position()

func summon(place_position: Vector2):
	for i in range(3):
		var new_knight: Summon = jollibee_knight_crew.instantiate()
		summon_node.add_child(new_knight)
		new_knight.global_position = place_position + Vector2(randi_range(-30, 30), randi_range(-30, 30))
	

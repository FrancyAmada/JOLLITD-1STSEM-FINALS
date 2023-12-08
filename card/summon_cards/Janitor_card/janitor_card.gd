extends Card

var janitor: PackedScene = preload("res://card/summon_cards/Janitor_card/janitor.tscn")


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
	for i in range(1):
		var new_janitor = janitor.instantiate()
		summon_node.add_child(new_janitor)
		new_janitor.set_summon_id(player_id)
#		print_debug("Player ID: ", player_id, " Summon:", new_waiter)
		new_janitor.global_position = place_position + Vector2(randi_range(-50, 50), randi_range(-50, 50))
		


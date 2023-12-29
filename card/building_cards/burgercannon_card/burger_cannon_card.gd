extends Card

var bucketcannon: PackedScene = preload("res://card/building_cards/burgercannon_card/burger_cannon.tscn")


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
		var new_bucketcannon = bucketcannon.instantiate()
		summon_node.add_child(new_bucketcannon)
		new_bucketcannon.set_summon_id(player_id)
#		print_debug("Player ID: ", player_id, " Summon:", new_waiter)
		new_bucketcannon.global_position = place_position
		


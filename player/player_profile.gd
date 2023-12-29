extends Node

class_name Profile

var profile_name: String = ""
var deck: Array
var deck_index: Array


func set_profile(profile_data: Dictionary):
	profile_name = profile_data["profile"]["name"]
	for card_index in profile_data["deck"]:
		deck.append(Global.available_cards[int(card_index)])
	deck_index = profile_data["deck"]
	print_debug(deck, deck_index)

func saveObject():
	var dict := {
		"profile": {
			"name": profile_name,
			},
		"deck": deck_index
	}
	return dict
	
func loadObject():
	pass
	

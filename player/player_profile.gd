extends Node

class_name Profile

var profile_name: String = ""
var deck: Array


func set_profile(profile_data: Dictionary):
	profile_name = profile_data["profile"]["name"]
	deck = profile_data["deck"]

func saveObject():
	var dict := {
		"profile": {
			"name": profile_name,
			},
		"deck": deck
	}
	return dict
	
func loadObject():
	pass
	

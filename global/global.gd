extends Node

# Cards List 
@onready var available_cards: Array = [
	# Summons
	preload("res://card/summon_cards/waiter_card/waiter_card.tscn"),
	preload("res://card/summon_cards/intern_card/intern_card.tscn"),
	preload("res://card/summon_cards/janitor_card/janitor_card.tscn"),
	preload("res://card/summon_cards/manager_card/manager_card.tscn"),
	preload("res://card/summon_cards/security_card/security_card.tscn"),
	preload("res://card/summon_cards/chef_card/chef_card.tscn"),
	preload("res://card/summon_cards/rider_card/rider_card.tscn"),
	preload("res://card/summon_cards/hr_agent_card/hr_agent_card.tscn"),
	
	# Towers
	preload("res://card/building_cards/bucketcannon_card/bucket_cannon_card.tscn"),
]

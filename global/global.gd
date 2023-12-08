extends Node

# Cards List
@onready var available_cards: Array = [
	preload("res://card/summon_cards/waiter_card/waiter_card.tscn"),
	preload("res://card/summon_cards/intern_card/intern_card.tscn"),
	preload("res://card/summon_cards/janitor_card/janitor_card.tscn")
]

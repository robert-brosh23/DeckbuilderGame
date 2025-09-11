class_name GameManager
extends Node2D

@onready var hours_label := $HoursLabel

@export var card_data_debug: Array[CardData]

var hours: int:
	set(value):
		hours = value
		hours_label.text = "Hours remaining: " + str(self.hours)

func _ready() -> void:
	hours = 8
	var cards = CardsManager.create_cards(card_data_debug)
	CardsManager.call_deferred("add_cards_to_deck", cards) # call after deck is set up

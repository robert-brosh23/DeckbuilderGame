class_name GameManager
extends Node2D

@onready var hours_label := $HoursLabel
@onready var cards_manager := $CardsManager

@export var card_data_debug: Array[CardData]

var hours: int:
	set(value):
		hours = value
		hours_label.text = "Hours remaining: " + str(self.hours)

func _ready() -> void:
	hours = 8
	var cards = cards_manager.create_cards(card_data_debug)
	cards_manager.add_cards_to_deck(cards)

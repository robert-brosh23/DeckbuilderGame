class_name GameManager
extends Control

const STARTING_HOURS := 8

@onready var hours_label := $MarginContainer/VBoxContainer2/HBoxContainer2/HoursLabel
@onready var mental_health_bar = $MarginContainer/VBoxContainer2/HBoxContainer/ProgressBar
@onready var day_label := $"MarginContainer/VBoxContainer2/HBoxContainer3/Day Label"

@export var card_data_debug: Array[CardData]

var mental_health: int = 10:
	set(value):
		mental_health = value
		mental_health_bar.value = value

var hours: int:
	set(value):
		hours = value
		hours_label.text = "Hours remaining: " + str(self.hours)
		
var day: int:
	set(value):
		day = value
		day_label.text = "Day : " + str(self.day)

var hours_next_day = 0

func _ready() -> void:
	hours = STARTING_HOURS
	day = 1
	var cards = await CardsManager.create_cards(card_data_debug)
	
func go_to_next_day() -> void:
	CardsManager.discard_all_cards()
	CardsManager.move_cards_from_discard_pile_to_deck_and_shuffle()
	hours = STARTING_HOURS + hours_next_day
	hours_next_day = 0
	day += 1
	CardsManager.draw_multiple_cards(5)

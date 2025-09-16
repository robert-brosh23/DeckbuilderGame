# class_name GameManager
extends Control

const STARTING_HOURS := 8

var main_ui: MainUi

@export var card_data_debug: Array[CardData]

var mental_health: int = 10:
	set(value):
		mental_health = value
		main_ui.set_mental_health_bar_value(value)

var hours: int:
	set(value):
		hours = value
		main_ui.set_hours_label(value)
		
var day: int:
	set(value):
		day = value
		main_ui.set_day_label(day)

func _ready() -> void:
	await get_tree().process_frame
	main_ui = get_tree().get_first_node_in_group("main_ui")
	hours = STARTING_HOURS
	day = 1
	var cards = await CardsController.create_cards(card_data_debug)
	
func go_to_next_day() -> void:
	CardsController.discard_all_cards()
	CardsController.move_cards_from_discard_pile_to_deck_and_shuffle()
	day += 1
	hours = STARTING_HOURS
	SignalBus.new_day_started.emit()
	CardsController.draw_multiple_cards(5)

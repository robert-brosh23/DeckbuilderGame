# class_name GameManager
extends Control

const STARTING_HOURS := 8

@export var card_data_debug: Array[CardData]

var main_ui: MainUi
var promise_queue: PromiseQueue
var receiving_input = true
var score = 0;

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
	promise_queue = CardsController.promise_queue
	CardsController.enqueue_create_cards(card_data_debug)
	
func go_to_next_day() -> void:
	receiving_input = false
	await CardsController.enqueue_discard_all_cards_from_hand()
	await CardsController.enqueue_move_cards_from_discard_pile_to_deck_and_shuffle()
	day += 1
	hours = STARTING_HOURS
	SignalBus.new_day_started.emit()
	receiving_input = true
	CardsController.enqueue_draw_multiple_cards(5)

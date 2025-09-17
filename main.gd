class_name Main
extends Node2D

@export var deck: Deck
@export var hand: Hand
@export var discard_pile: DiscardPile

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("draw_card"):
		debug_draw_card_from_deck()
	if Input.is_action_just_pressed("re_shuffle_deck"):
		debug_move_cards_from_discard_pile_to_deck_and_reshuffle()
	if Input.is_action_just_pressed("discard_card_from_deck"):
		debug_discard_card_from_deck()
	if Input.is_action_just_pressed("debug_add_hours"):
		debug_add_hours()
	if Input.is_action_just_pressed("debug_decrease_mental_health"):
		debug_decrease_mental_health()
	if Input.is_action_just_pressed("debug_next_day"):
		debug_next_day()
	
func debug_draw_card_from_deck() -> void:
	CardsController.enqueue_draw_card_from_deck()
	
func debug_discard_card_from_deck() -> void:
	CardsController.enqueue_discard_card_from_deck()
	
func debug_move_cards_from_discard_pile_to_deck_and_reshuffle() -> void:
	CardsController.enqueue_move_cards_from_discard_pile_to_deck_and_shuffle()

func debug_add_hours() -> void:
	GameManager.hours += 8
	
func debug_decrease_mental_health() -> void:
	GameManager.mental_health -= 1
	
func debug_next_day() -> void:
	GameManager.go_to_next_day()

class_name Main
extends Node2D

@export var deck: Deck
@export var hand: Hand
@export var discard_pile: DiscardPile
@export var game_manager: GameManager

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
	
func debug_draw_card_from_deck() -> void:
	CardsManager.draw_card_from_deck()
	
func debug_discard_card_from_deck() -> void:
	CardsManager.discard_card_from_deck()
	
func debug_move_cards_from_discard_pile_to_deck_and_reshuffle() -> void:
	CardsManager.move_cards_from_discard_pile_to_deck_and_shuffle()

func debug_add_hours() -> void:
	game_manager.hours += 8

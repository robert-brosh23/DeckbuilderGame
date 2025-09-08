class_name Main
extends Node2D

@export var deck: Deck
@export var hand: Hand
@export var discard_pile: DiscardPile

func _ready() -> void:
	move_card_to_deck($Cards/Card)
	move_card_to_deck($Cards/Card2)
	move_card_to_deck($Cards/Card3)
	move_card_to_deck($Cards/Card4)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("draw_card"):
		draw_card_from_deck()
	if Input.is_action_just_pressed("re_shuffle_deck"):
		move_cards_from_discard_pile_to_deck_and_reshuffle()
	
func draw_card_from_deck() -> void:
	var card = deck.draw_card()
	if card == null:
		return
	move_card_to_hand(card)
	
func discard_card_from_deck() -> void:
	var card = deck.draw_card()
	if card == null:
		print("no card in deck")
		return
	discard_pile.append_card_to_discard_pile(card)
	
func move_cards_from_discard_pile_to_deck_and_reshuffle() -> void:
	var arr: Array[Card] = discard_pile.remove_all_cards_from_discard_pile()
	deck.append_multiple_cards_to_deck(arr)
	deck.shuffle_deck()

func move_card_to_deck(card: Card) -> void:
	deck.append_card_to_deck(card)
	
func move_card_to_hand(card: Card) -> void:
	hand.append_card_to_hand(card)

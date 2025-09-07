class_name Main
extends Node2D

@export var movement_tween_manager: MovementTweenManager
@export var deck: Deck
@export var hand: Hand
@export var discard_pile: DiscardPile

func _ready() -> void:
	move_card_to_deck($Card)
	move_card_to_deck($Card2)
	move_card_to_deck($Card3)
	move_card_to_hand($Card4)
	
	var tween = create_tween()
	tween.tween_callback(func():
		draw_card_from_deck()
	).set_delay(1.0)
	
	tween.tween_callback(func():
		draw_card_from_deck()
	).set_delay(1.0)
	
	tween.tween_callback(func():
		draw_card_from_deck()
	).set_delay(1.0)
	
	tween.tween_callback(func():
		draw_card_from_deck()
	).set_delay(1.0)
	
	tween.tween_callback(func():
		draw_card_from_deck()
	).set_delay(1.0)
	
	tween.tween_callback(func():
		move_card_to_deck(hand.remove_card_from_hand(0))
	).set_delay(1.0)
	
	tween.tween_callback(func():
		move_card_to_deck(hand.remove_card_from_hand(0))
	).set_delay(1.0)
	
	tween.tween_callback(func():
		move_card_to_deck(hand.remove_card_from_hand(0))
	).set_delay(1.0)
	
	tween.tween_callback(func():
		move_card_to_deck(hand.remove_card_from_hand(0))
	).set_delay(1.0)
	
	tween.tween_callback(func():
		deck.shuffle_deck()
	).set_delay(1.0)
	
	tween.tween_callback(func():
		draw_card_from_deck()
	).set_delay(1.0)
	
	tween.tween_callback(func():
		draw_card_from_deck()
	).set_delay(1.0)
	
	tween.tween_callback(func():
		move_card_to_deck(hand.remove_card_from_hand(0))
	).set_delay(1.0)
	
	tween.tween_callback(func():
		draw_card_from_deck()
	).set_delay(1.0)
	
	tween.tween_callback(func():
		discard_card_from_deck()
	).set_delay(1.0)
	
	tween.tween_callback(func():
		discard_card_from_hand(1)
	).set_delay(1.0)
	
	tween.tween_callback(func():
		discard_card_from_hand(0)
	).set_delay(1.0)
	
	tween.tween_callback(func():
		discard_card_from_deck()
	).set_delay(1.0)
	
	tween.tween_callback(func():
		move_cards_from_discard_pile_to_deck_and_reshuffle()
	).set_delay(1.0)
	
	tween.tween_callback(func():
		draw_card_from_deck()
	).set_delay(1.0)
	
func draw_card_from_deck() -> void:
	var card = deck.draw_card()
	if card == null:
		print("no card in deck")
		return
	move_card_to_hand(card)
	
func discard_card_from_hand(index: int) -> void:
	var card = hand.remove_card_from_hand(index)
	discard_pile.append_card_to_discard_pile(card)
	
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

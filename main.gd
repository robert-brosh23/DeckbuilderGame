class_name Main
extends Node2D

@export var movement_tween_manager: MovementTweenManager
@export var deck: Deck
@export var hand: Hand

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
	
	
func draw_card_from_deck() -> void:
	var card = deck.draw_card()
	if card == null:
		print("no card in deck")
		return
	move_card_to_hand(card)

func move_card_to_deck(card: Card) -> void:
	deck.append_card_to_deck(card)
	
func move_card_to_hand(card: Card) -> void:
	hand.append_card_to_hand(card)

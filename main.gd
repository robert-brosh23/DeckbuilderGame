class_name Main
extends Node2D

@export var movement_tween_manager: MovementTweenManager
@export var deck: Deck
@export var hand: Hand

func _ready() -> void:
	move_card_to_deck($Card)
	move_card_to_hand($Card2)
	move_card_to_hand($Card3)
	
	var tween = create_tween()
	tween.tween_callback(func():
		move_card_to_hand($Card4)
	).set_delay(2.0)

func move_card_to_deck(card: Card) -> void:
	deck.append_card_to_deck(card)
	
func move_card_to_hand(card: Card) -> void:
	hand.append_card_to_hand(card)

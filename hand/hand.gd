class_name Hand
extends Node2D

const CENTER_X = 0
const DEFAULT_Y = 170.0
const DEFAULT_CARD_SEPARATION = 70

@export var cards: Array[Card]
@export var movement_tween_manager: MovementTweenManager

func _ready() -> void:
	update_hand()

func append_card_to_hand(card: Card) -> void:
	card.flip_card_up()
	cards.append(card)
	update_hand()
	
func remove_card_from_hand(index: int) -> Card:
	if index >= cards.size():
		print("Error: Index out of range (card in hand)")
		return
	var card = cards[index]
	cards.remove_at(index)
	update_hand()
	return card

func update_hand():
	var card_separation: int = determine_card_separation()
	var hand_length: int = card_separation * (cards.size() - 1)
	var x_pos: int = CENTER_X - hand_length / 2 
	var z_index: int = 1
	
	for card in cards:
		movement_tween_manager.tween_to_pos(card, Vector2(x_pos, DEFAULT_Y))
		card.z_index = z_index
		
		x_pos += card_separation
		z_index += 1

func determine_card_separation() -> int:
	return DEFAULT_CARD_SEPARATION - cards.size() * 4

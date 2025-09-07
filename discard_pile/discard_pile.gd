class_name DiscardPile
extends Node2D

@export var movement_tween_manager: MovementTweenManager
@export var cards: Array[Card]

func append_card_to_discard_pile(card: Card) -> void:
	if card == null:
		print("Error: no card to append to discard pile")
		return
	card.flip_card_up()
	cards.push_front(card)
	update_z_indexes()
	movement_tween_manager.tween_to_pos(card, self.position, 1.0)
	card.visible = true
	
func remove_card_from_discard_pile(index: int) -> Card:
	if cards.size() == 0:
		print("Discard pile is empty, cannot get card")
		return null
	var card = cards[0]
	cards.remove_at(0)
	update_z_indexes()
	return card
	
func remove_all_cards_from_discard_pile() -> Array[Card]:
	var arr: Array[Card] = []
	while true:
		var card = remove_card_from_discard_pile(0)
		if card == null:
			break
		arr.append(card)
	return arr

func update_z_indexes() -> void:
	for i in range(0, cards.size() - 1, 1):
		cards[i].z_index = cards.size() - i

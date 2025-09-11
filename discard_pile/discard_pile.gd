class_name DiscardPile
extends Node2D

## Cards appended to the discard pile are pushed to the front of cards array
func sync_card_addition(card: Card) -> void:
	if card == null:
		print("Error: no card to append to discard pile")
		return
	card.flip_card_up()
	card.hoverable = false
	_update_z_indexes()
	card.movement_tween_manager.tween_to_pos(card, self.position, 1.0)
	card.visible = true
	
func remove_card_from_discard_pile(index: int) -> Card:
	if index >= CardsManager.cards_in_discard_pile.size():
		print("Error: Index out of range of discard pile.")
		return null
	var card = CardsManager.cards_in_discard_pile[index]
	CardsManager.cards_in_discard_pile.remove_at(index)
	_update_z_indexes()
	return card
	
func remove_all_cards_from_discard_pile() -> Array[Card]:
	var arr: Array[Card] = []
	while CardsManager.cards_in_discard_pile.size() > 0:
		var card = remove_card_from_discard_pile(0)
		arr.append(card)
	return arr

func _update_z_indexes() -> void:
	for i in range(0, CardsManager.cards_in_discard_pile.size(), 1):
		CardsManager.cards_in_discard_pile[i].z_index = CardsManager.cards_in_discard_pile.size() - i

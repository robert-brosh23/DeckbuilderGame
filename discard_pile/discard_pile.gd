class_name DiscardPile
extends Node2D

@export var cards: Array[Card]

## Cards appended to the discard pile are pushed to the front of cards array
func append_card_to_discard_pile(card: Card) -> void:
	if card == null:
		print("Error: no card to append to discard pile")
		return
	card.flip_card_up()
	card.hoverable = false
	cards.push_front(card)
	update_z_indexes()
	card.movement_tween_manager.tween_to_pos(card, self.position, 1.0)
	card.visible = true
	
	# There is a bug with panel's mouse signals. When two nodes have the same parent, the node that is lower will take priority for these signals regardless of z index.
	# That's why we need to move nodes around.
	card.get_parent().move_child(card,1)
	
func remove_card_from_discard_pile(index: int) -> Card:
	if index >= cards.size():
		print("Error: Index out of range of discard pile.")
		return null
	var card = cards[index]
	cards.remove_at(index)
	update_z_indexes()
	return card
	
func remove_all_cards_from_discard_pile() -> Array[Card]:
	var arr: Array[Card] = []
	while cards.size() > 0:
		var card = remove_card_from_discard_pile(0)
		arr.append(card)
	return arr

func update_z_indexes() -> void:
	for i in range(0, cards.size(), 1):
		cards[i].z_index = cards.size() - i

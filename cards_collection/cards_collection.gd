extends Node
## Global object which holds all player cards.
# This class is required because of a panel mouse signals bug. The fields should be manipulated elsewhere.

var cards_in_deck: Array[Card]
var cards_in_hand: Array[Card]
var cards_in_discard_pile: Array[Card]
var deleted_cards: Array[Card]

# NODE MOVEMENT WORKAROUND FUNCTIONS
func move_card_node_in_hand(card: Card, index: int) -> void:
	move_child(card, index)
	
func move_card_node_to_deck(card: Card) -> void:
	move_child(card, 0)
	
func move_card_node_to_discard(card: Card) -> void:
	move_child(card, 0)

func reset():
	for card in cards_in_deck:
		card.queue_free()
	cards_in_deck.clear()
	
	for card in cards_in_hand:
		card.queue_free()
	cards_in_hand.clear()
	
	for card in cards_in_discard_pile:
		card.queue_free()
	cards_in_discard_pile.clear()
	
	for card in deleted_cards:
		card.queue_free()
	deleted_cards.clear()

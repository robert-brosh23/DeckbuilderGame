extends Node
## Global object which holds all player cards.
# This class is required because of a panel mouse signals bug. The fields should be manipulated elsewhere.

var cards_in_deck: Array[Card]
var cards_in_hand: Array[Card]
var cards_in_discard_pile: Array[Card]

# NODE MOVEMENT WORKAROUND FUNCTIONS
func move_card_node_in_hand(card: Card, index: int) -> void:
	move_child(card, index)
	
func move_card_node_to_deck(card: Card) -> void:
	move_child(card, 0)
	
func move_card_node_to_discard(card: Card) -> void:
	move_child(card, 0)

extends Node

var cards: Array[Card]

var deck: Deck

func _ready() -> void:
	deck = get_tree().get_first_node_in_group("deck")

func create_card(card_data: CardData) -> Card:
	var card = Card.create_card(card_data)
	add_child(card)
	cards.push_back(card)
	return card

func create_cards(card_datas: Array[CardData]) -> Array[Card]:
	var arr: Array[Card] = []
	for card_data in card_datas:
		var card = create_card(card_data)
		arr.push_back(card)
	return arr
		
func add_card_to_deck(new_card: Card) -> void:
	deck.append_card_to_deck(new_card)
	
func add_cards_to_deck(new_cards: Array[Card]) -> void:
	for new_card in new_cards:
		add_card_to_deck(new_card)
		
func _order_cards_in_tree() -> void:
	pass

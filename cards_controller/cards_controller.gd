extends Node

var deck: Deck
var hand: Hand
var discard_pile: DiscardPile

func _ready() -> void:
	deck = get_tree().get_first_node_in_group("deck")
	discard_pile = get_tree().get_first_node_in_group("discard_pile")
	hand = get_tree().get_first_node_in_group("hand")
	
	var promise_queue: PromiseQueue = PromiseQueue.new()
	deck.promise_queue = promise_queue
	hand.promise_queue = promise_queue

## Creates a new card and adds it to the deck. Returns reference to the card created.
func create_card(card_data: CardData) -> Card:
	var card = Card.create_card(card_data)
	CardsCollection.add_child(card)
	add_card_to_deck(card)
	return card

## Creates new cards and adds them to the deck. Returns a list of references to the cards created.
func create_cards(card_datas: Array[CardData]) -> Array[Card]:
	var arr: Array[Card] = []
	for card_data in card_datas:
		var card = create_card(card_data)
		arr.push_back(card)
	return arr


# DECK FUNCTIONS
func draw_card_from_deck() -> void:
	var card = await deck.enqueue_draw_card()
	if card == null:
		return
	add_card_to_hand(card)

func draw_multiple_cards(num_cards: int) -> void:
	for i in range(0, num_cards):
		draw_card_from_deck()
		
func discard_card_from_deck() -> void:
	var card = await deck.enqueue_draw_card()
	if card == null:
		print("no card in deck")
		return
	add_card_to_discard_pile(card)

func add_card_to_deck(card: Card) -> void:
	deck.enqueue_add_card(card)
	
func add_cards_to_deck(new_cards: Array[Card]) -> void:
	for new_card in new_cards:
		add_card_to_deck(new_card)
	

# HAND FUNCTIONS
func add_card_to_hand(card: Card) -> void:
	hand.add_card(card)

	
# DISCARD PILE FUNCTIONS
func add_card_to_discard_pile(card: Card) -> void:
	if card == null:
		print("Error: no card to append to discard pile")
		return
	discard_pile.add_card(card)
	
func discard_card(card: Card) -> void:
	hand.remove_card_from_hand(card)
	CardsController.add_card_to_discard_pile(card)
	
func discard_all_cards() -> void:
	while !CardsCollection.cards_in_hand.is_empty():
		discard_card(CardsCollection.cards_in_hand.front())
	
func move_cards_from_discard_pile_to_deck_and_shuffle() -> void:
	var arr: Array[Card] = discard_pile.remove_all_cards_from_discard_pile()
	add_cards_to_deck(arr)
	deck.enqueue_shuffle_deck()

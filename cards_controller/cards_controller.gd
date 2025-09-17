extends Node

var deck: Deck
var hand: Hand
var discard_pile: DiscardPile
var promise_queue: PromiseQueue = PromiseQueue.new()

func _ready() -> void:
	deck = get_tree().get_first_node_in_group("deck")
	discard_pile = get_tree().get_first_node_in_group("discard_pile")
	hand = get_tree().get_first_node_in_group("hand")
	
	deck.promise_queue = promise_queue
	hand.promise_queue = promise_queue

## Creates a new card and adds it to the deck. Returns reference to the card created.
func enqueue_create_card(card_data: CardData) -> Card:
	var result_signal = promise_queue.enqueue(_create_card.bind(card_data))
	promise_queue.enqueue_delay(.2)
	var result = await result_signal
	return result
	
func _create_card(card_data: CardData) -> Card:
	var card = Card.create_card(card_data)
	card.promise_queue = promise_queue
	CardsCollection.add_child(card)
	deck.add_card(card)
	return card

## Creates new cards and adds them to the deck.
func enqueue_create_cards(card_datas: Array[CardData]) -> void:
	for card_data in card_datas:
		enqueue_create_card(card_data)


# DECK FUNCTIONS
func enqueue_draw_card_from_deck() -> void:
	var result_signal = promise_queue.enqueue(draw_card_from_deck)
	promise_queue.enqueue_delay(.2)
	
func enqueue_front_draw_card_from_deck() -> void:
	var result_signal = promise_queue.enqueue_front(draw_card_from_deck)
	promise_queue.enqueue_delay_front(.2)
	
func draw_card_from_deck() -> void:
	var card = deck.draw_card()
	if card == null:
		return
	hand.add_card(card)

func enqueue_draw_multiple_cards(num_cards: int) -> void:
	for i in range(0, num_cards):
		enqueue_draw_card_from_deck()
		
func enqueue_discard_card_from_deck() -> void:
	var result_signal = promise_queue.enqueue(_discard_card_from_deck)
	promise_queue.enqueue_delay(.2)
	
func _discard_card_from_deck() -> void:
	var card = deck.draw_card()
	if card == null:
		print("no card in deck")
		return
	discard_pile.add_card(card)
	
func enqueue_shuffle_deck() -> void:
	var result_signal = promise_queue.enqueue(_shuffle_deck)
	
func _shuffle_deck() -> void:
	await get_tree().create_timer(0.5).timeout
	deck.shuffle_deck()
	await get_tree().create_timer(0.5).timeout


# HAND FUNCTIONS
## Try to play the card. Returns true if the card was played, false otherwise.
func enqueue_play_card(card: Card) -> bool:
	var result_signal = promise_queue.enqueue(_play_card.bind(card))
	promise_queue.enqueue_delay(.2)
	var result = await result_signal
	return result

func _play_card(card: Card) -> bool:
	var result = card.play_card()
	if result == true:
		_discard_card_from_hand(card)
		return true
	hand.return_card(card)
	return false

func enqueue_discard_card_from_hand(card: Card) -> void:
	var result_signal = promise_queue.enqueue(_discard_card_from_hand.bind(card))
	promise_queue.enqueue_delay(.2)

func _discard_card_from_hand(card: Card) -> void:
	card.state = Card.states.NOT_IN_HAND
	hand.remove_card_from_hand(card)
	discard_pile.add_card(card)
	
	
func enqueue_discard_all_cards_from_hand() -> void:
	var result_signal = promise_queue.enqueue(_discard_all_cards_from_hand)
	promise_queue.enqueue_delay(.5)
	
func _discard_all_cards_from_hand() -> void:
	while !CardsCollection.cards_in_hand.is_empty():
		var card = hand.remove_card_from_hand(CardsCollection.cards_in_hand.front())
		card.state = Card.states.NOT_IN_HAND
		discard_pile.add_card(card)
		await get_tree().create_timer(0.2).timeout
	
	
# DISCARD PILE FUNCTIONS
func _add_card_to_discard_pile(card: Card) -> void:
	if card == null:
		print("Error: no card to append to discard pile")
		return
	discard_pile.add_card(card)
	
func enqueue_move_cards_from_discard_pile_to_deck_and_shuffle() -> void:
	var result_signal = promise_queue.enqueue(move_cards_from_discard_pile_to_deck_and_shuffle)
	
func enqueue_front_move_cards_from_discard_pile_to_deck_and_shuffle() -> void:
	var result_signal = promise_queue.enqueue_front(move_cards_from_discard_pile_to_deck_and_shuffle)
	
func move_cards_from_discard_pile_to_deck_and_shuffle() -> void:
	var arr: Array[Card] = discard_pile.remove_all_cards_from_discard_pile()
	deck.add_cards(arr)
	await get_tree().create_timer(0.5).timeout
	deck.shuffle_deck()
	await get_tree().create_timer(0.5).timeout

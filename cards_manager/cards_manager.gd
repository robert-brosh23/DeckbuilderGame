extends Node

var cards_in_deck: Array[Card]
var cards_in_hand: Array[Card]
var cards_in_discard_pile: Array[Card]

var deck: Deck
var hand: Hand
var discard_pile: DiscardPile

func _ready() -> void:
	deck = get_tree().get_first_node_in_group("deck")
	discard_pile = get_tree().get_first_node_in_group("discard_pile")
	hand = get_tree().get_first_node_in_group("hand")

## Creates a new card and adds it to the deck. Returns reference to the card created.
func create_card(card_data: CardData) -> Card:
	var card = Card.create_card(card_data)
	add_child(card)
	add_card_to_deck(card)
	return card

## Creates new cards and adds them to the deck. Returns a list of references to the cards created.
func create_cards(card_datas: Array[CardData]) -> Array[Card]:
	var arr: Array[Card] = []
	deck.receiving_cards = true
	for card_data in card_datas:
		var card = create_card(card_data)
		arr.push_back(card)
		await get_tree().create_timer(.1 * Globals.animation_speed_scale).timeout
	await get_tree().create_timer(deck.CARD_MOVEMENT_DURATION * Globals.animation_speed_scale).timeout
	deck.receiving_cards = false
	return arr


# DECK FUNCTIONS
func draw_card_from_deck() -> void:
	var card = deck.draw_card()
	if card == null:
		return
	add_card_to_hand(card)

func draw_multiple_cards(num_cards: int) -> void:
	for i in range(0, num_cards):
		draw_card_from_deck()
		await get_tree().create_timer(.1 * Globals.animation_speed_scale).timeout
		
func discard_card_from_deck() -> void:
	var card = deck.draw_card()
	if card == null:
		print("no card in deck")
		return
	add_card_to_discard_pile(card)

func add_card_to_deck(card: Card) -> void:
	cards_in_deck.append(card)
	deck.sync_card_addition(card)
	
func add_cards_to_deck(new_cards: Array[Card]) -> void:
	if new_cards.size() == 0:
		return
	
	deck.receiving_cards = true
	for new_card in new_cards:
		add_card_to_deck(new_card)
		await get_tree().create_timer(.1 * Globals.animation_speed_scale).timeout
	await get_tree().create_timer(deck.CARD_MOVEMENT_DURATION * Globals.animation_speed_scale).timeout
	deck.receiving_cards = false
	

# HAND FUNCTIONS
func add_card_to_hand(card: Card) -> void:
	cards_in_hand.append(card)
	hand.sync_card_addition(card)

	
# DISCARD PILE FUNCTIONS
func add_card_to_discard_pile(card: Card) -> void:
	cards_in_discard_pile.push_front(card)
	discard_pile.sync_card_addition(card)
	move_child(card, 0)
	
func discard_card(card: Card) -> void:
	hand.remove_card_from_hand(card)
	CardsManager.add_card_to_discard_pile(card)
	
func discard_all_cards() -> void:
	while !cards_in_hand.is_empty():
		discard_card(cards_in_hand.front())
	
func move_cards_from_discard_pile_to_deck_and_shuffle() -> void:
	var arr: Array[Card] = discard_pile.remove_all_cards_from_discard_pile()
	add_cards_to_deck(arr)
	deck.shuffle_deck()
		
		
# NODE MOVEMENT WORKAROUND FUNCTIONS
## Index = index in hand
func move_card_node_in_hand(card: Card, index: int) -> void:
	move_child(card, index) # Convert index in hand to index for all cards
	
func move_card_node_to_deck(card: Card) -> void:
	move_child(card, 0)
	
func move_card_node_to_discard(card: Card) -> void:
	move_child(card, 0)

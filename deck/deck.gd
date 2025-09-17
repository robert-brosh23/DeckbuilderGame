class_name Deck
extends Control

const CARD_MOVEMENT_DURATION := 1.0

@onready var card_amount_label := $CardAmountLabel

var promise_queue: PromiseQueue

func _ready() -> void:
	_update_card_number_text()
	
func _process(delta: float) -> void:
	pass

func add_card(card: Card) -> void:
	card.flip_card_down()
	card.movement_tween_manager.tween_to_pos(card, self.position, CARD_MOVEMENT_DURATION).finished.connect(func(): _update_card_number_text())
	CardsCollection.cards_in_deck.append(card)
	_update_top_card_z_index()
	
func add_cards(cards: Array[Card]):
	for card in cards:
		add_card(card)
	
func draw_card() -> Card:
	if CardsCollection.cards_in_deck.is_empty():
		print("Deck is empty. Cannot draw card")
		return null
	var card = CardsCollection.cards_in_deck[0]
	CardsCollection.cards_in_deck.remove_at(0)
	_update_card_number_text()
	_update_top_card_z_index()
	
	var tween = create_tween()
	return card
	
func shuffle_deck() -> void:
	print("shuffling deck...")
	var tween = create_tween()
	for i in range(CardsCollection.cards_in_deck.size() - 1, 0, -1):
		var j = randi() % (i + 1)
		var temp = CardsCollection.cards_in_deck[i]
		CardsCollection.cards_in_deck[i] = CardsCollection.cards_in_deck[j]
		CardsCollection.cards_in_deck[j] = temp
	_update_top_card_z_index()
	
func _update_card_number_text() -> void:
	card_amount_label.text = "Cards: " + str(CardsCollection.cards_in_deck.size())
		
func _update_top_card_z_index() -> void:
	if CardsCollection.cards_in_deck.size() == 0:
		return
	CardsCollection.cards_in_deck[0].z_index = 1
	for i in range(1, CardsCollection.cards_in_deck.size(), 1):
		CardsCollection.cards_in_deck[i].z_index = 0

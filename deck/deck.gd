class_name Deck
extends Node2D

const CARD_MOVEMENT_DURATION := 1.0

@onready var card_amount_label := $CardAmountLabel

var shuffling = false
var receiving_cards = false

func _ready() -> void:
	_update_card_number_text()
	
func sync_card_addition(card: Card) -> void:
	if card == null:
		print("Error: no card to append to deck")
		return
	card.flip_card_down()
	card.movement_tween_manager.tween_to_pos(card, self.position, CARD_MOVEMENT_DURATION).finished.connect(func(): _update_card_number_text())
	_update_top_card_z_index()
	
func draw_card() -> Card:
	if shuffling || receiving_cards:
		print("Deck is being updated. Cannot draw cards")
		return null
		
	if CardsManager.cards_in_deck.size() == 0:
		print("Deck is empty, cannot draw card")
		return null
		
	var card = CardsManager.cards_in_deck[0]
	CardsManager.cards_in_deck.remove_at(0)
	_update_card_number_text()
	_update_top_card_z_index()
	
	return card
	
func shuffle_deck() -> void:
	if shuffling || receiving_cards:
		return
	
	print("shuffling deck...")
	shuffling = true
	var tween = create_tween()
	tween.tween_callback(func():
		for i in range(CardsManager.cards_in_deck.size() - 1, 0, -1):
			var j = randi() % (i + 1)
			var temp = CardsManager.cards_in_deck[i]
			CardsManager.cards_in_deck[i] = CardsManager.cards_in_deck[j]
			CardsManager.cards_in_deck[j] = temp
		shuffling = false
		_update_top_card_z_index()
	).set_delay(1.2 * Globals.animation_speed_scale)
	
func _update_card_number_text() -> void:
	card_amount_label.text = "Cards: " + str(CardsManager.cards_in_deck.size())
		
func _update_top_card_z_index() -> void:
	if CardsManager.cards_in_deck.size() == 0:
		return
	CardsManager.cards_in_deck[0].z_index = 1
	for i in range(1, CardsManager.cards_in_deck.size(), 1):
		CardsManager.cards_in_deck[i].z_index = 0

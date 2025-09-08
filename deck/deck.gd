class_name Deck
extends Node2D

@export var cards: Array[Card]
@export var hand: Hand

@onready var panel = $Panel
@onready var card_amount_label = $CardAmountLabel

func _ready() -> void:
	update_card_number_text()
	
func append_card_to_deck(card: Card) -> void:
	if card == null:
		print("Error: no card to append to deck")
		return
	card.flip_card_down()
	cards.append(card)
	card.movement_tween_manager.tween_to_pos(card, self.position, 1.0).finished.connect(func(): update_card_number_text())
	card.movement_tween_manager.tween_visible(card, false, 1.0)
	
func append_multiple_cards_to_deck(arr: Array[Card]) -> void:
	for card in arr:
		append_card_to_deck(card)
		await get_tree().create_timer(.1 * Globals.animation_speed_scale).timeout
	
func draw_card() -> Card:
	if cards.size() == 0:
		print("Deck is empty, cannot draw card")
		return null
		
	var card = cards[0]
	cards.remove_at(0)
	update_card_number_text()
	card.visible = true
	return card
	
func shuffle_deck() -> void:
	print("shuffling deck...")
	for i in range(cards.size() - 1, 0, -1):
		var j = randi() % (i + 1)
		var temp = cards[i]
		cards[i] = cards[j]
		cards[j] = temp
	
func update_card_number_text() -> void:
	card_amount_label.text = "Cards: " + str(cards.size())
	if cards.size() == 0:
		panel.visible = false
	else:
		panel.visible = true

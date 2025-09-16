class_name Hand
extends Control

const CENTER_X = 0
const DEFAULT_Y = 170.0
const DEFAULT_CARD_SEPARATION = 150
const HAND_BASE_Z_INDEX = 200

@onready var play_color_rect := $ColorRect

@export var discard_pile: DiscardPile

var promise_queue: PromiseQueue
var hovered_card: Card = null
var dragging := false
var drag_offset: Vector2
var dragged_card: Card

func _ready() -> void:
	play_color_rect.visible = false
	_update_hand()
	
func _process(_delta: float) -> void:
	_handle_input()

func add_card(card: Card) -> void:
	CardsCollection.cards_in_hand.append(card)
	card.flip_card_up()
	card.hoverable = true
	if not card.panel.mouse_exited.is_connected(_stop_hover_card):
		card.panel.mouse_exited.connect(_stop_hover_card)
	if not card.panel.mouse_entered.is_connected(_hover_card):
		card.panel.mouse_entered.connect(_hover_card.bind(card))
	_update_hand()
	
func enqueue_play_card(card: Card) -> void:
	var result_signal = promise_queue.enqueue(_play_card.bind(card))
	card.hoverable = false
	promise_queue.enqueue_delay(.2)
	
func _play_card(card: Card) -> void:
	var result = card.play_card()
	if result == true:
		CardsController.discard_card(card)
		return
	_return_card(card)
	
func remove_card_from_hand(card: Card) -> Card:
	if card == hovered_card:
		hovered_card = null
	if card == dragged_card:
		dragging = false
		dragged_card = null
	card.hoverable = false
	CardsCollection.cards_in_hand.erase(card)
	_update_hand()
	return card

func _handle_input() -> void:
	if Input.is_action_just_pressed("click"):
		if hovered_card != null:
			dragging = true
			dragged_card = hovered_card
			drag_offset = hovered_card.global_position - get_viewport().get_mouse_position()
			play_color_rect.visible = true
			
	if dragging:
		dragged_card.global_position = get_viewport().get_mouse_position() + drag_offset
		
	if Input.is_action_just_released("click"):
		if dragging == false:
			return
		dragging = false
		hovered_card = null
		var returning_card = dragged_card
		dragged_card = null
		play_color_rect.visible = false
		
		var mouse_pos = get_viewport().get_mouse_position()
		if mouse_pos.y < play_color_rect.position.y + play_color_rect.size.y && mouse_pos.x > play_color_rect.position.x && mouse_pos.x < play_color_rect.position.x + play_color_rect.size.x:
			enqueue_play_card(returning_card)
			_update_hand()
			return
		
		_return_card(returning_card)
	
func _hover_card(card: Card) -> void:
	print("hover")
	if card.hoverable == false || dragging:
		return
		
	# There is a bug with panel's mouse signals. When two nodes have the same parent, the node that is lower will take priority for these signals regardless of z index.
	# That's why we need to move nodes around.
	CardsCollection.move_card_node_in_hand(card,CardsCollection.cards_in_hand.size() + CardsCollection.cards_in_deck.size() + CardsCollection.cards_in_discard_pile.size())
	hovered_card = card
	card.z_index = CardsCollection.cards_in_hand.size() + CardsCollection.cards_in_deck.size() + CardsCollection.cards_in_discard_pile.size()
	card.hover_card()
	
func _stop_hover_card() -> void:
	hovered_card = null
	_update_hand()
	
func _return_card(returning_card: Card) -> void:
	_update_hand()
	
	var tween = create_tween()
	returning_card.hoverable = false
	tween.tween_callback(func():
		returning_card.hoverable = true
	).set_delay(1.0 * Globals.animation_speed_scale)
	

func _update_hand():
	var card_separation: int = _determine_card_separation()
	var hand_length: int = card_separation * (CardsCollection.cards_in_hand.size() - 1)
	var x_pos: int = CENTER_X - hand_length / 2 
	var z_index: int = CardsCollection.cards_in_deck.size() + CardsCollection.cards_in_discard_pile.size()
	
	for card in CardsCollection.cards_in_hand:
		var y_pos = card.position.y if card == hovered_card else DEFAULT_Y
		if card != dragged_card:
			card.movement_tween_manager.tween_to_pos(card, Vector2(x_pos, y_pos))
			if card != hovered_card:
				card.z_index = z_index
				
				# There is a bug with panel's mouse signals. When two nodes have the same parent, the node that is lower will take priority for these signals regardless of z index.
				# That's why we need to move nodes around.
				CardsCollection.move_card_node_in_hand(card, z_index)
				
				z_index += 1
		x_pos += card_separation

func _determine_card_separation() -> int:
	return DEFAULT_CARD_SEPARATION / 4 + DEFAULT_CARD_SEPARATION * 3 / 4 / (CardsCollection.cards_in_hand.size() + 1)
	

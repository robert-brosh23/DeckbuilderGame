class_name Hand
extends Node2D

const CENTER_X = 0
const DEFAULT_Y = 170.0
const DEFAULT_CARD_SEPARATION = 70

@onready var play_color_rect := $ColorRect

@export var discard_pile: DiscardPile

@export var cards: Array[Card]
var hovered_card: Card = null

var dragging := false
var drag_offset: Vector2
var dragged_card: Card

func _ready() -> void:
	play_color_rect.visible = false
	update_hand()
	
func _process(delta: float) -> void:
	handle_input()

func handle_input() -> void:
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
			play_card(returning_card)
			update_hand()
			return
		
		update_hand()
		
		var tween = create_tween()
		returning_card.hoverable = false
		tween.tween_callback(func():
			returning_card.hoverable = true
		).set_delay(1.0 * Globals.animation_speed_scale)

func append_card_to_hand(card: Card) -> void:
	card.flip_card_up()
	card.hoverable = true
	cards.append(card)
	card.panel.mouse_exited.connect(stop_hover_card)
	card.panel.mouse_entered.connect(Callable(self, "hover_card").bind(card))
	update_hand()
	
func remove_card_from_hand(card: Card) -> Card:
	cards.erase(card)
	update_hand()
	return card
	
func hover_card(card: Card) -> void:
	if card.hoverable == false || dragging:
		return
	card.get_parent().move_child(card,cards.size()-1)
	hovered_card = card
	card.hover_card()
	
func stop_hover_card() -> void:
	hovered_card = null
	update_hand()
	
func play_card(card: Card) -> void:
	var result = card.play_card()
	if result == true:
		discard_card(card)
	
func discard_card(card: Card) -> void:
	remove_card_from_hand(card)
	if discard_pile == null:
		return
	discard_pile.append_card_to_discard_pile(card)

func update_hand():
	var card_separation: int = determine_card_separation()
	var hand_length: int = card_separation * (cards.size() - 1)
	var x_pos: int = CENTER_X - hand_length / 2 
	var z_index: int = 1
	
	for card in cards:
		var y_pos = card.position.y if card == hovered_card else DEFAULT_Y
		if card != dragged_card:
			card.movement_tween_manager.tween_to_pos(card, Vector2(x_pos, y_pos))
			if card != hovered_card:
				card.z_index = z_index
				card.get_parent().move_child(card,z_index-1)
				z_index += 1
		x_pos += card_separation

func determine_card_separation() -> int:
	return DEFAULT_CARD_SEPARATION - cards.size() * 4
	

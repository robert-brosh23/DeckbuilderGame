class_name Card
extends Control

const SELECTED_CARD_Y_OFFSET = 48.0
const DEFAULT_POS_Y = 170.0

const TECH_STYLEBOX_PATH = "res://card/card_data/styles/stylebox/tech_stylebox.tres"
const TECH_STYLEBOX_IMAGE_FRAME_PATH = "res://card/card_data/styles/stylebox/image_frame_tech_stylebox.tres"
const ART_STYLEBOX_PATH = "res://card/card_data/styles/stylebox/art_stylebox.tres"
const ART_STYLEBOX_IMAGE_FRAME_PATH = "res://card/card_data/styles/stylebox/image_frame_art_stylebox.tres"
const SPIRIT_STYLEBOX_PATH = "res://card/card_data/styles/stylebox/standard_stylebox.tres"
const SPIRIT_STYLEBOX_IMAGE_FRAME_PATH = "res://card/card_data/styles/stylebox/image_frame_standard_stylebox.tres"
const OBSTACLE_STYLEBOX_PATH = "res://card/card_data/styles/stylebox/obstacle_stylebox.tres"
const OBSTACLE_STYLEBOX_IMAGE_FRAME_PATH = "res://card/card_data/styles/stylebox/image_frame_obstacle_stylebox.tres"
const FACE_DOWN_CARD_STYLEBOX_PATH = "res://card/card_data/styles/stylebox/face_down_card_stylebox.tres"

@export var card_data: CardData
@export var movement_tween_manager: MovementTweenManager
var game_manager: GameManager

@onready var panel: Panel = $Panel
@onready var margin_container = $Panel/MarginContainer
@onready var panel_container = $Panel/MarginContainer/VBoxContainer/PanelContainer
@onready var title_label = $Panel/MarginContainer/VBoxContainer/HBoxContainer/TitleLabel
@onready var texture_label = $Panel/MarginContainer/VBoxContainer/PanelContainer/TextureRect
@onready var description_label = $Panel/MarginContainer/VBoxContainer/DescriptionLabel
@onready var animation_player = $AnimationPlayer
@onready var cost_panel_margin_container = $Panel/MarginContainer/VBoxContainer/HBoxContainer/CostPanelMarginContainer
@onready var cost_label = $Panel/MarginContainer/VBoxContainer/HBoxContainer/CostPanelMarginContainer/CostPanel/CostLabel

var flipped_up: bool = true
var selected_font = FontFile
var state: states = states.NOT_IN_HAND
var promise_queue: PromiseQueue

enum states {READY, NOT_IN_HAND, HOVERING, DRAGGING, PLAYING, RETURNING}

## Creates a new card, given the card_data
static func create_card(card_data: CardData) -> Card:
	var instance = preload("res://card/card.tscn").instantiate()
	instance.card_data = card_data
	return instance

func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("game_manager")
	animation_player.speed_scale = 1.0 / Globals.animation_speed_scale
	_set_card_data()

## Returns true if the card was played, false if it cannot be played
func play_card() -> bool:
	var hours_cost = card_data.card_cost
	if hours_cost > game_manager.hours:
		print("This card costs too much.")
		return false
	
	game_manager.hours -= hours_cost
	play_card_effect()
	print (card_data.card_name, " was played.")
	return true
	
## Execute the card's specific played effect.
func play_card_effect() -> void:
	promise_queue.paused = true
	await call(card_data.effect_map[card_data.card_effect])
	promise_queue.paused = false
	
func hover_card() -> void:
	state = states.HOVERING
	movement_tween_manager.tween_to_pos(self, Vector2(position.x, 170.0 - SELECTED_CARD_Y_OFFSET), .1)
	
func flip_card_up() -> void:
	if flipped_up == true:
		return
	flipped_up = true
	animation_player.play("flip_card_up")
	
func flip_card_down() -> void:
	if flipped_up == false:
		return
	flipped_up = false
	animation_player.play("flip_card_down")
	
func apply_card_visual_facedown() -> void:
	var stylebox: StyleBoxFlat = preload(FACE_DOWN_CARD_STYLEBOX_PATH)
	panel.add_theme_stylebox_override("panel", stylebox)
	margin_container.visible = false

func apply_card_visual_faceup() -> void:
	if card_data == null:
		return
		
	if card_data.card_type == CardData.CARD_TYPE.SPIRIT:
		pass
	
	match card_data.card_type:
		CardData.CARD_TYPE.TECH:
			_apply_card_type_visual_tech()
		CardData.CARD_TYPE.ART:
			_apply_card_type_visual_art()
		CardData.CARD_TYPE.SPIRIT:
			_apply_card_type_visual_spirit()
		CardData.CARD_TYPE.OBSTACLE:
			_apply_card_type_visual_obstacle()
			
	var font := card_data.get_font()
	title_label.add_theme_font_override("font", font)
	
	margin_container.visible = true

func _set_card_data() -> void:
	if card_data == null:
		return
	
	title_label.text = card_data.card_name
	texture_label.texture = card_data.card_png
	description_label.text = card_data.card_description
	cost_label.text = str(card_data.card_cost)
	_apply_spacer_container_margin()

## TECH CARD TYPE
func _apply_card_type_visual_tech() -> void:
	panel.add_theme_stylebox_override("panel", _get_tech_stylebox())
	panel_container.add_theme_stylebox_override("panel", _get_tech_image_frame_stylebox())
	_apply_tech_fonts()

func _get_tech_stylebox() -> StyleBox:
	var stylebox: StyleBoxFlat = preload(TECH_STYLEBOX_PATH)
	return stylebox
	
func _get_tech_image_frame_stylebox() -> StyleBox:
	var stylebox: StyleBoxFlat = preload(TECH_STYLEBOX_IMAGE_FRAME_PATH)
	return stylebox
	
func _apply_tech_fonts() -> void:
	title_label.add_theme_color_override("font_color", "ffe7d6")
	description_label.add_theme_color_override("font_color", "ffe7d6")


## ART CARD TYPE
func _apply_card_type_visual_art() -> void:
	panel.add_theme_stylebox_override("panel", _get_art_stylebox())
	panel_container.add_theme_stylebox_override("panel", _get_art_image_frame_stylebox())
	_apply_art_fonts()

func _get_art_stylebox() -> StyleBox:
	var stylebox: StyleBoxFlat = preload(ART_STYLEBOX_PATH)
	return stylebox
	
func _get_art_image_frame_stylebox() -> StyleBox:
	var stylebox: StyleBoxFlat = preload(ART_STYLEBOX_IMAGE_FRAME_PATH)
	return stylebox
	
func _apply_art_fonts() -> void:
	title_label.add_theme_color_override("font_color", "ab5675")
	description_label.add_theme_color_override("font_color", "ab5675")


## SPIRIT CARD TYPE
func _apply_card_type_visual_spirit() -> void:
	panel.add_theme_stylebox_override("panel", _get_spirit_stylebox())
	panel_container.add_theme_stylebox_override("panel", _get_spirit_image_frame_stylebox())
	_apply_standard_fonts()

func _get_spirit_stylebox() -> StyleBox:
	var stylebox: StyleBoxFlat = preload(SPIRIT_STYLEBOX_PATH)
	return stylebox
	
func _get_spirit_image_frame_stylebox() -> StyleBox:
	var stylebox: StyleBoxFlat = preload(SPIRIT_STYLEBOX_IMAGE_FRAME_PATH)
	return stylebox
	
func _apply_standard_fonts() -> void:
	title_label.add_theme_color_override("font_color", "ab5675")
	description_label.add_theme_color_override("font_color", "ab5675")


## OBSTACLE CARD TYPE
func _apply_card_type_visual_obstacle() -> void:
	panel.add_theme_stylebox_override("panel", _get_obstacle_stylebox())
	panel_container.add_theme_stylebox_override("panel", _get_obstacle_image_frame_stylebox())
	_apply_obstacle_fonts()

func _get_obstacle_stylebox() -> StyleBox:
	var stylebox: StyleBoxFlat = preload(OBSTACLE_STYLEBOX_PATH)
	return stylebox
	
func _get_obstacle_image_frame_stylebox() -> StyleBox:
	var stylebox: StyleBoxFlat = preload(OBSTACLE_STYLEBOX_IMAGE_FRAME_PATH)
	return stylebox
	
func _apply_obstacle_fonts() -> void:
	title_label.add_theme_color_override("font_color", "ffe7d6")
	description_label.add_theme_color_override("font_color", "ffe7d6")
	
func _apply_spacer_container_margin() -> void:
	cost_panel_margin_container.add_theme_constant_override("margin_right", -11 + card_data.card_title_offset)
	
	
# CARD EFFECT FUNCTIONS
func _execute_new_day():
	game_manager.mental_health = 10
	
func _execute_meditation():
	await CardsController.move_cards_from_discard_pile_to_deck_and_shuffle()
	await CardsController.draw_card_from_deck()
	await get_tree().create_timer(.2).timeout
	
func _execute_organize():
	SignalBus.new_day_started.connect(
		func(): game_manager.hours += 2,
		CONNECT_ONE_SHOT
	)
	
func _execute_brain_blast():
	for i in range(0,3):
		await CardsController.draw_card_from_deck()
		await get_tree().create_timer(.2).timeout

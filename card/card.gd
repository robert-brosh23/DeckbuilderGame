class_name Card
extends Control

const SELECTED_CARD_Y_OFFSET = 48.0
const DEFAULT_POS_Y = 350.0

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
var projects_manager: ProjectsManager

var cost := 0

enum states {READY, NOT_IN_HAND, HOVERING, DRAGGING, PLAYING, RETURNING, PREVIEW_PICKING, DELETING}

## Creates a new card, given the card_data
static func create_card(card_data: CardData) -> Card:
	var instance = preload("res://card/card.tscn").instantiate()
	instance.card_data = card_data
	instance.cost = card_data.card_cost
	return instance

func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("game_manager")
	projects_manager = get_tree().get_first_node_in_group("projects_manager")
	animation_player.speed_scale = 1.0 / Globals.animation_speed_scale
	apply_card_visual_faceup()
	_set_card_data()

## Check to see if the card can be played, and play it.
## target: the project targeted with this card. Will be null if the card doesn't need a target
## Returns true if the card was played, false if it cannot be played
func play_card(target: Project) -> bool:
	if cost > game_manager.hours:
		print("This card costs too much.")
		return false
	
	game_manager.hours -= cost
	play_card_effect(target)
	print (card_data.card_name, " was played.")
	return true
	
func delete_card() -> void:
	state = states.DELETING
	animation_player.play("delete")
	CardsCollection.cards_in_hand.erase(self)
	CardsCollection.deleted_cards.append(self)
	
## Execute the card's specific played effect.
func play_card_effect(target: Project) -> void:
	var effect := card_data.effect_map[card_data.card_effect]
	if effect == CardData.NO_EFFECT:
		return
	
	promise_queue.paused = true
	if target == null:
		await call(card_data.effect_map[card_data.card_effect])
	else:
		await call(card_data.effect_map[card_data.card_effect], target)
		
	SignalBus.card_played.emit(self, target)
	promise_queue.paused = false
	
func draw_card_effect() -> void:
	var effect := card_data.draw_effect_map[card_data.card_effect]
	if effect == CardData.NO_EFFECT:
		return
	
	promise_queue.paused = true
	await call(card_data.draw_effect_map[card_data.card_effect])
	promise_queue.paused = false
	
func hover_card() -> void:
	state = states.HOVERING
	movement_tween_manager.tween_to_pos(self, Vector2(position.x, DEFAULT_POS_Y - SELECTED_CARD_Y_OFFSET), .1)
	
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
	
func apply_card_visual_selected() -> void:
	var sb := panel.get("theme_override_styles/panel") as StyleBoxFlat
	var copy = sb.duplicate()
	copy.border_color = "ffa7a5"
	panel.add_theme_stylebox_override("panel", copy)

func apply_card_visual_facedown() -> void:
	var stylebox: StyleBoxFlat = preload(FACE_DOWN_CARD_STYLEBOX_PATH)
	panel.add_theme_stylebox_override("panel", stylebox)
	margin_container.visible = false

func apply_card_visual_faceup() -> void:
	if card_data == null:
		return
	
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
	cost_label.text = str(cost)
	
	if card_data.get_target_type() == CardData.target_type.UNPLAYABLE:
		cost_panel_margin_container.visible = false
	else:
		cost_panel_margin_container.visible = true	
	
	description_label.add_theme_constant_override("line_spacing", card_data.desc_line_spacing)
	
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
	title_label.add_theme_color_override("font_color", Constants.COLOR_PURPLE)
	description_label.add_theme_color_override("font_color", Constants.COLOR_PURPLE)


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
	game_manager.stress = 3
	
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
		
func _execute_clean():
	var conditions: Array[Callable] = [func(card: Card): return card.card_data.card_type != CardData.CARD_TYPE.OBSTACLE]
	delete_card()
	var result := await CardsController.select_cards(3, conditions)
	
	for card in result:
		card.delete_card()
	var hand: Hand = get_tree().get_first_node_in_group("hand")
	hand._update_hand()
	
func _execute_small_step(target: Project):
	target.add_step_and_progress()
	
func _execute_touch_grass():
	GameManager.stress -= 1
	
func _execute_friendship():
	GameManager.stress -= 1
	if cost != 0:
		cost -= 1
		_set_card_data()
		
func _execute_grind(target: Project):
	target.progress(1)
	
func _execute_community_support():
	SignalBus.card_played.connect(_trigger_community_support, CONNECT_ONE_SHOT)
	
	SignalBus.new_day_started.connect(
		func(): 
			if SignalBus.card_played.is_connected(_trigger_community_support):
				SignalBus.card_played.disconnect(_trigger_community_support)
			, CONNECT_ONE_SHOT
	)
	
func _trigger_community_support(card: Card, target: Project):
	if card.card_data.card_effect == CardData.CARD_EFFECT.COMMUNITY_SUPPORT:
		SignalBus.card_played.connect(_trigger_community_support, CONNECT_ONE_SHOT)
		return
		
	await card.play_card_effect(target)
	
func _delete_self():
	delete_card()
	
func _execute_mental_health_day():
	game_manager.stress = 0
	for card in CardsCollection.cards_in_hand:
		if card.card_data.card_type == CardData.CARD_TYPE.OBSTACLE:
			card.delete_card()
	
# DRAW EFFECTS
func _draw_effect_comparison():
	game_manager.stress += 2
	projects_manager.projects[randi() % projects_manager.projects.size()].progress(3)
	
func _draw_effect_addiction():
	game_manager.hours -= 3
	

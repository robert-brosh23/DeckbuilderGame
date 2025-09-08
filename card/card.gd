class_name Card
extends Node2D

const SELECTED_CARD_Y_OFFSET = 48.0
const DEFAULT_POS_Y = 170.0

const STANDARD_STYLEBOX_PATH = "res://card/card_data/styles/stylebox/standard_stylebox.tres"
const STANDARD_STYLEBOX_IMAGE_FRAME_PATH = "res://card/card_data/styles/stylebox/image_frame_standard_stylebox.tres"
const OBSTACLE_STYLEBOX_PATH = "res://card/card_data/styles/stylebox/obstacle_stylebox.tres"
const OBSTACLE_STYLEBOX_IMAGE_FRAME_PATH = "res://card/card_data/styles/stylebox/image_frame_obstacle_stylebox.tres"
const FACE_DOWN_CARD_STYLEBOX_PATH = "res://card/card_data/styles/stylebox/face_down_card_stylebox.tres"

@export var card_data: CardData
@export var movement_tween_manager: MovementTweenManager

@onready var panel: Panel = $Panel
@onready var margin_container = $Panel/MarginContainer
@onready var panel_container = $Panel/MarginContainer/VBoxContainer/PanelContainer
@onready var title_label = $Panel/MarginContainer/VBoxContainer/TitleLabel
@onready var texture_label = $Panel/MarginContainer/VBoxContainer/PanelContainer/TextureRect
@onready var description_label = $Panel/MarginContainer/VBoxContainer/DescriptionLabel
@onready var animation_player = $AnimationPlayer

var flipped_up: bool = false
var selected_font = FontFile
var hoverable: bool = false

func _ready() -> void:
	animation_player.speed_scale = 1.0 / Globals.animation_speed_scale
	set_card_data()
		
func set_card_data() -> void:
	if card_data == null:
		return
	
	title_label.text = card_data.card_name
	texture_label.texture = card_data.card_png
	description_label.text = card_data.card_description
	
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
	
func move_card_to_deck(deck_pos: Vector2) -> void:
	movement_tween_manager.tween_to_pos(self, deck_pos, 1.0)
	movement_tween_manager.tween_visible(self, false, 1.0)
	hoverable = false
	
func apply_card_visual_facedown() -> void:
	var stylebox: StyleBoxFlat = preload(FACE_DOWN_CARD_STYLEBOX_PATH)
	panel.add_theme_stylebox_override("panel", stylebox)
	margin_container.visible = false

func apply_card_visual_faceup() -> void:
	if card_data == null:
		return
		
	if card_data.card_type == CardData.CARD_TYPE.STANDARD:
		pass
	
	match card_data.card_type:
		CardData.CARD_TYPE.STANDARD:
			apply_card_type_visual_standard()
		CardData.CARD_TYPE.OBSTACLE:
			apply_card_type_visual_obstacle()
			
	margin_container.visible = true
	
	
## STANDARD CARD TYPE
func apply_card_type_visual_standard() -> void:
	panel.add_theme_stylebox_override("panel", get_standard_stylebox())
	panel_container.add_theme_stylebox_override("panel", get_standard_image_frame_stylebox())
	apply_standard_fonts()

func get_standard_stylebox() -> StyleBox:
	var stylebox: StyleBoxFlat = preload(STANDARD_STYLEBOX_PATH)
	return stylebox
	
func get_standard_image_frame_stylebox() -> StyleBox:
	var stylebox: StyleBoxFlat = preload(STANDARD_STYLEBOX_IMAGE_FRAME_PATH)
	return stylebox
	
func apply_standard_fonts() -> void:
	title_label.add_theme_color_override("font_color", "ab5675")
	description_label.add_theme_color_override("font_color", "ab5675")
	

## OBSTACLE CARD TYPE
func apply_card_type_visual_obstacle() -> void:
	panel.add_theme_stylebox_override("panel", get_obstacle_stylebox())
	panel_container.add_theme_stylebox_override("panel", get_obstacle_image_frame_stylebox())
	apply_obstacle_fonts()

func get_obstacle_stylebox() -> StyleBox:
	var stylebox: StyleBoxFlat = preload(OBSTACLE_STYLEBOX_PATH)
	return stylebox
	
func get_obstacle_image_frame_stylebox() -> StyleBox:
	var stylebox: StyleBoxFlat = preload(OBSTACLE_STYLEBOX_IMAGE_FRAME_PATH)
	return stylebox
	
func apply_obstacle_fonts() -> void:
	title_label.add_theme_color_override("font_color", "ffe7d6")
	description_label.add_theme_color_override("font_color", "ffe7d6")
	
func _on_panel_mouse_entered() -> void:
	if hoverable:
		hover_card()
		
func hover_card() -> void:
	movement_tween_manager.tween_to_pos(self, Vector2(position.x, 170.0 - SELECTED_CARD_Y_OFFSET), .1)
	z_index = 15
		

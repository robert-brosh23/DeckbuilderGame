class_name CardData
extends Resource

@export var card_name: String

@export var card_cost: int

@export var card_png: CompressedTexture2D

@export var card_description: String

@export var card_type: CARD_TYPE

@export var card_effect: CARD_EFFECT

@export var title_font: CARD_FONT = CARD_FONT.FIVE_BY_SEVEN

## If the card title is too long, and overlapping the cost panel, increase this offset to move it off center.
@export_range(0, 12) var card_title_offset := 0

var effect_map: Dictionary[CARD_EFFECT, String] = {
	CARD_EFFECT.NEW_DAY: "_execute_new_day",
	CARD_EFFECT.MEDITATION: "_execute_meditation",
	CARD_EFFECT.ORGANIZE: "_execute_organize",
	CARD_EFFECT.BRAIN_BLAST: "_execute_brain_blast",
	CARD_EFFECT.CLEAN: "_execute_clean"
}

enum CARD_TYPE {
	TECH,
	ART,
	SPIRIT,
	OBSTACLE
}

enum CARD_FONT {
	THREE_BY_SIX,
	FIVE_BY_SEVEN
}

enum CARD_EFFECT {
	NEW_DAY,
	MEDITATION,
	ORGANIZE,
	BRAIN_BLAST,
	CLEAN
}

func get_font() -> Font:
	var font: Font
	if title_font == CARD_FONT.THREE_BY_SIX:
		font = load("res://fonts/m3x6.ttf")
		return font
	font = load("res://fonts/m5x7.ttf")
	return font

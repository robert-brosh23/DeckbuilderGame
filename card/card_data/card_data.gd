class_name CardData
extends Resource

@export var card_name: String

@export var card_cost: int

@export var card_png: CompressedTexture2D

@export var card_description: String

@export var card_type: CARD_TYPE

@export var title_font: CARD_FONT = CARD_FONT.FIVE_BY_SEVEN

## If the card title is too long, and overlapping the cost panel, increase this offset to move it off center.
@export_range(0, 12) var card_title_offset := 0

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

func get_font() -> Font:
	var font: Font
	if title_font == CARD_FONT.THREE_BY_SIX:
		font = load("res://fonts/m3x6.ttf")
		return font
	font = load("res://fonts/m5x7.ttf")
	return font

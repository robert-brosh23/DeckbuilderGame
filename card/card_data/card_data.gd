class_name CardData
extends Resource

@export var card_name: String

@export var card_cost: int

@export var card_png: CompressedTexture2D

@export var card_description: String

@export var card_type: CARD_TYPE

## If the card title is too long, and overlapping the cost panel, increase this offset to move it off center.
@export_range(0, 12) var card_title_offset := 0

enum CARD_TYPE {
	TECH,
	ART,
	SPIRIT,
	OBSTACLE
}

func play_card_effect() -> void:
	# Effect taken when card is played
	pass

func draw_card_effect() -> void:
	# Effect taken when card is drawn from the deck
	pass

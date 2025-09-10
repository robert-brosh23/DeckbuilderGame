class_name CardData
extends Resource

@export var card_name: String = "Card Name"

@export var card_cost: int = 0

@export var card_png: CompressedTexture2D = load("res://sprites/heart.png")

@export var card_description: String = "This is a description of what the card does. What kind of card is this?"

@export var card_type: CARD_TYPE = CARD_TYPE.STANDARD

## If the card title is too long, and overlapping the cost panel, increase this offset to move it off center.
@export_range(0, 12) var card_title_offset := 0

enum CARD_TYPE {
	STANDARD,
	OBSTACLE
}

func play_card_effect() -> void:
	# Effect taken when card is played
	pass

func draw_card_effect() -> void:
	# Effect taken when card is drawn from the deck
	pass

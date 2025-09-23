class_name CardData
extends Resource

const NO_EFFECT := "NO_EFFECT"

@export var card_name: String

@export var card_cost: int

@export var card_png: CompressedTexture2D

@export var card_description: String

@export var card_type: CARD_TYPE

@export var card_effect: CARD_EFFECT

@export var title_font: CARD_FONT = CARD_FONT.FIVE_BY_SEVEN

@export var desc_line_spacing := -2

## If the card title is too long, and overlapping the cost panel, increase this offset to move it off center.
@export_range(0, 12) var card_title_offset := 0

var effect_map: Dictionary[CARD_EFFECT, String] = {
	CARD_EFFECT.NEW_DAY: "_execute_new_day",
	CARD_EFFECT.MEDITATION: "_execute_meditation",
	CARD_EFFECT.ORGANIZE: "_execute_organize",
	CARD_EFFECT.BRAIN_BLAST: "_execute_brain_blast",
	CARD_EFFECT.CLEAN: "_execute_clean",
	CARD_EFFECT.SMALL_STEP: "_execute_small_step",
	CARD_EFFECT.COMPARISON: NO_EFFECT,
	CARD_EFFECT.TOUCH_GRASS: "_execute_touch_grass",
	CARD_EFFECT.MENTAL_HEALTH_DAY: "_execute_mental_health_day",
	CARD_EFFECT.FRIENDSHIP: "_execute_friendship",
	CARD_EFFECT.GRIND_LOGIC: "_execute_grind",
	CARD_EFFECT.GRIND_CREATIVITY: "_execute_grind",
	CARD_EFFECT.GRIND_WISDOM: "_execute_grind",
	CARD_EFFECT.COMMUNITY_SUPPORT: "_execute_community_support",
	CARD_EFFECT.SLEEP_DEPRIVED: "_delete_self",
	CARD_EFFECT.ADDICTION: NO_EFFECT,
}

var draw_effect_map: Dictionary[CARD_EFFECT, String] = {
	CARD_EFFECT.NEW_DAY: NO_EFFECT,
	CARD_EFFECT.MEDITATION: NO_EFFECT,
	CARD_EFFECT.ORGANIZE: NO_EFFECT,
	CARD_EFFECT.BRAIN_BLAST: NO_EFFECT,
	CARD_EFFECT.CLEAN: NO_EFFECT,
	CARD_EFFECT.SMALL_STEP: NO_EFFECT,
	CARD_EFFECT.COMPARISON: "_draw_effect_comparison",
	CARD_EFFECT.TOUCH_GRASS: NO_EFFECT,
	CARD_EFFECT.MENTAL_HEALTH_DAY: NO_EFFECT,
	CARD_EFFECT.FRIENDSHIP: NO_EFFECT,
	CARD_EFFECT.GRIND_LOGIC: NO_EFFECT,
	CARD_EFFECT.GRIND_CREATIVITY: NO_EFFECT,
	CARD_EFFECT.GRIND_WISDOM: NO_EFFECT,
	CARD_EFFECT.COMMUNITY_SUPPORT: NO_EFFECT,
	CARD_EFFECT.SLEEP_DEPRIVED: NO_EFFECT,
	CARD_EFFECT.ADDICTION: "_draw_effect_addiction"
}

var target_type_map: Dictionary[CARD_EFFECT, target_type] = {
	CARD_EFFECT.NEW_DAY: target_type.ALL,
	CARD_EFFECT.MEDITATION: target_type.ALL,
	CARD_EFFECT.ORGANIZE: target_type.ALL,
	CARD_EFFECT.BRAIN_BLAST: target_type.ALL,
	CARD_EFFECT.CLEAN: target_type.ALL,
	CARD_EFFECT.SMALL_STEP: target_type.SINGLE,
	CARD_EFFECT.COMPARISON: target_type.UNPLAYABLE,
	CARD_EFFECT.TOUCH_GRASS: target_type.ALL,
	CARD_EFFECT.MENTAL_HEALTH_DAY: target_type.ALL,
	CARD_EFFECT.FRIENDSHIP: target_type.ALL,
	CARD_EFFECT.GRIND_LOGIC: target_type.SINGLE,
	CARD_EFFECT.GRIND_CREATIVITY: target_type.SINGLE,
	CARD_EFFECT.GRIND_WISDOM: target_type.SINGLE,
	CARD_EFFECT.COMMUNITY_SUPPORT: target_type.ALL,
	CARD_EFFECT.SLEEP_DEPRIVED: target_type.ALL,
	CARD_EFFECT.ADDICTION: target_type.UNPLAYABLE
}

## Project targeted cards must have project bound.
var target_conditions_map: Dictionary[CARD_EFFECT, Array] = {
	CARD_EFFECT.GRIND_LOGIC: [_project_is_logic],
	CARD_EFFECT.GRIND_CREATIVITY: [_project_is_creativity],
	CARD_EFFECT.GRIND_WISDOM: [_project_is_wisdom],
	CARD_EFFECT.COMMUNITY_SUPPORT: [_no_community_support_in_play]
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
	CLEAN,
	SMALL_STEP,
	COMPARISON,
	TOUCH_GRASS,
	MENTAL_HEALTH_DAY,
	FRIENDSHIP,
	GRIND_LOGIC,
	GRIND_CREATIVITY,
	GRIND_WISDOM,
	COMMUNITY_SUPPORT,
	SLEEP_DEPRIVED,
	ADDICTION
}

enum target_type {
	SINGLE,
	MULTI,
	ALL,
	UNPLAYABLE
}

func _no_community_support_in_play() -> bool:
	print("connections: ", SignalBus.card_played.get_connections())
	for connection in SignalBus.card_played.get_connections():
		var callable : Callable = connection["callable"]
		if callable.get_method() == "_trigger_community_support":
			return false
	return true

func _project_not_creativity(project: Project):
	return project.template.type != project.template.project_type.CREATIVITY
	
func _project_is_creativity(project: Project):
	return project.template.type == project.template.project_type.CREATIVITY
	
func _project_is_logic(project: Project):
	return project.template.type == project.template.project_type.LOGIC
	
func _project_is_wisdom(project: Project):
	return project.template.type == project.template.project_type.WISDOM

func get_target_type() -> target_type:
	return target_type_map[card_effect]

func get_target_conditions() -> Array:
	if target_conditions_map.has(card_effect):
		return target_conditions_map[card_effect]
	return []

func get_font() -> Font:
	var font: Font
	if title_font == CARD_FONT.THREE_BY_SIX:
		font = load("res://fonts/m3x6.ttf")
		return font
	font = load("res://fonts/m5x7.ttf")
	return font

class_name ResolveData
extends Resource

@export var resolve_name: String

@export var effect: resolve_effect 

@export var texture_png: CompressedTexture2D

@export var tooltip: String

var counter := -1

enum resolve_effect {
	SPAWN_POINT,
	DISCIPLINE,
	EARLY_BIRD,
	TRUST,
	MORNING_JOGGER,
	REFRAMED_THINKING
}

var effect_map: Dictionary[resolve_effect, Callable] = {
	resolve_effect.SPAWN_POINT : _create_spawn_point,
	resolve_effect.DISCIPLINE : _create_discipline,
	resolve_effect.EARLY_BIRD : _create_early_bird,
	resolve_effect.TRUST : _create_trust,
	resolve_effect.MORNING_JOGGER: _create_morning_jogger,
	resolve_effect.REFRAMED_THINKING: _create_reframed_thinking
}

func get_effect_callable(effect: resolve_effect) -> Callable:
	return effect_map[effect]

func _create_spawn_point():
	SignalBus.new_day_started.connect(
		func(day: int):
			CardsController.enqueue_draw_card_from_deck()
	)
	
func _create_early_bird():
	SignalBus.new_day_started.connect(
		func(day: int):
			GameManager.hours += 1
	)
	
func _create_discipline():
	counter = 0
	SignalBus.card_played.connect(
		func(card: Card, project: Project):
			counter += 1
			if counter == 5:
				CardsController.enqueue_draw_card_from_deck()
				counter = 0
	)
	
func _create_trust():
	SignalBus.card_played.connect(
		func(card: Card, project: Project):
			if card.card_data.card_type == CardData.CARD_TYPE.SPIRIT:
				counter += 1
				if counter == 3:
					GameManager.hours += 5
					counter = 0
	)
	
func _create_morning_jogger():
	counter = 0
	SignalBus.card_played.connect(
		func(card: Card, project: Project):
			if card.card_data.card_type == CardData.CARD_TYPE.ART:
				counter += 1
				if counter == 4:
					if project == null:
						counter -= 1
					else:
						project.add_step_and_progress()
						counter = 0
	)
	
func _create_reframed_thinking():
	SignalBus.card_played.connect(
		func(card: Card, project: Project):
			if card.card_data.card_type == CardData.CARD_TYPE.TECH:
				CardsController.enqueue_draw_card_from_deck()
	)
	
	
	

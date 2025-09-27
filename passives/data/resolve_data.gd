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
	TRUST
}

var effect_map: Dictionary[resolve_effect, Callable] = {
	resolve_effect.SPAWN_POINT : _create_spawn_point,
	resolve_effect.DISCIPLINE : _create_discipline,
	resolve_effect.EARLY_BIRD : _create_early_bird,
	resolve_effect.TRUST : _create_trust
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
	SignalBus.new_day_started.connect(
		func(day: int):
			if randi() % 4 == 0:
				_execute_community_support()
	)

func _execute_community_support():
	SignalBus.start_card_played.connect(_trigger_community_support, CONNECT_ONE_SHOT)
	
	SignalBus.new_day_started.connect(
		func(): 
			if SignalBus.start_card_played.is_connected(_trigger_community_support):
				SignalBus.start_card_played.disconnect(_trigger_community_support)
			, CONNECT_ONE_SHOT
	)
	
func _trigger_community_support(card: Card, target: Project):
	while true:
		var args = await SignalBus.card_played
		var card_candidate: Card = args[0]
		if card_candidate == card:
			break
	await card.play_card_effect(target)
	
	
	
	
	

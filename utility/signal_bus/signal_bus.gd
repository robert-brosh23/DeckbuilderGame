extends Node

signal new_day_started(num_day: int)

signal alter_cost(multiplier: float)
var cost_multiplier := 1.0

var pending := []
signal start_card_played(card: Card, target: Project)
signal card_played(card: Card, target: Project)
signal card_played_chained(card: Card, target: Project)

func _ready() -> void:
	start_card_played.connect(
		func(card: Card, project: Project):
			pending.append(card)
	)
	card_played.connect(
		func(card: Card, project: Project):
			if pending.has(card):
				card_played_chained.emit(card, project)
				pending.erase(card)
	)

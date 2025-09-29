class_name HoursTracker
extends Control

@export var hours_label : Label
@export var end_day_button : Button
@export var big_arrow : Control
@export var animation_player: AnimationPlayer

var cursor: Cursor

var big_arrow_enabled := false:
	set(value):
		big_arrow_enabled = true
		if !GameManager.receiving_input:
			big_arrow.visible = false
			return
		if value:
			_check_cards_playable(null, null)
		else:
			big_arrow.visible = false
			

func _ready() -> void:
	end_day_button.focus_mode = FOCUS_NONE
	big_arrow.visible = false
	animation_player.play("wave_arrow")
	cursor = get_tree().get_first_node_in_group("cursor")
	
	SignalBus.card_played.connect(_check_cards_playable)
	SignalBus.new_day_started.connect(func(day: int): 
		#await get_tree().create_timer(1.0).timeout
		_check_cards_playable(null, null)
	)
			
func _check_cards_playable(c: Card, project: Project):
	for card in CardsCollection.cards_in_hand:
		if card != c && card.card_data.get_target_type() != CardData.target_type.UNPLAYABLE && card.cost <= GameManager.hours:
			big_arrow.visible = false
			return
	big_arrow.visible = true

func _on_end_day_button_pressed() -> void:
	if !CardsController.receiving_input():
		return
	big_arrow.visible = false
	GameManager.go_to_next_day()
	
func set_hours_label(hours: int):
	hours_label.text = "Hours: " + str(hours)

func _on_end_day_button_mouse_entered() -> void:
	SignalBus.node_hovered.emit(end_day_button)

func _on_end_day_button_mouse_exited() -> void:
	SignalBus.node_stop_hovered.emit(end_day_button)

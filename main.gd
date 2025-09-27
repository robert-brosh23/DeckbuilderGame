class_name Main
extends Control

@export var deck: Deck
@export var hand: Hand
@export var discard_pile: DiscardPile

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("draw_card"):
		debug_draw_card_from_deck()
	if Input.is_action_just_pressed("re_shuffle_deck"):
		debug_move_cards_from_discard_pile_to_deck_and_reshuffle()
	if Input.is_action_just_pressed("discard_card_from_deck"):
		debug_discard_card_from_deck()
	if Input.is_action_just_pressed("debug_add_hours"):
		debug_add_hours()
	if Input.is_action_just_pressed("debug_decrease_mental_health"):
		debug_increase_stress()
	if Input.is_action_just_pressed("debug_next_day"):
		debug_next_day()
	if Input.is_action_just_pressed("debug_select_cards"):
		debug_select_cards()
	if Input.is_action_just_pressed("debug_apply_progress"):
		debug_apply_progress()
	if Input.is_action_just_pressed("debug_add_new_card"):
		debug_add_new_card()
	
func debug_draw_card_from_deck() -> void:
	CardsController.enqueue_draw_card_from_deck()
	
func debug_discard_card_from_deck() -> void:
	CardsController.enqueue_discard_card_from_deck()
	
func debug_move_cards_from_discard_pile_to_deck_and_reshuffle() -> void:
	CardsController.enqueue_move_cards_from_discard_pile_to_deck_and_shuffle()

func debug_add_hours() -> void:
	GameManager.hours += 8
	
func debug_increase_stress() -> void:
	GameManager.stress += 1
	
func debug_next_day() -> void:
	GameManager.go_to_next_day()
	
func debug_select_cards() -> void:
	CardsController.enqueue_select_cards(4)
	
func debug_apply_progress() -> void:
	$ProjectsManager.projects[0].progress(1)
	
func debug_add_new_card() -> void:
	$CanvasLayer/CardRewardsMenu.preview_rewards(ProjectResource.project_type.OBSTACLE)

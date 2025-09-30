extends Control

const STARTING_HOURS := 8
const MAX_STRESS := 10
const MAX_STRESS_ACCUMULATION := 10

@export var card_data_debug: Array[CardData]

var main_ui: MainUi
var card_rewards_menu: CardRewardsMenu
var promise_queue: PromiseQueue
var projects_manager: ProjectsManager
var receiving_input = true
var hours_tracker: HoursTracker

var score: int = 0:
	set(value):
		score = value
		main_ui.set_score_label(score)

var stress: int:
	set(value):
		stress = clamp(value, 1, MAX_STRESS)
		main_ui.set_stress_label(stress)

var stress_accumulation: int = 0

var hours: int:
	set(value):
		hours = clamp(value, 0, 999)
		hours_tracker.set_hours_label(hours)
		
var day: int:
	set(value):
		day = value
		main_ui.set_day_label(day)

func reset():
	ready()

func ready() -> void:
	receiving_input = false
	await get_tree().process_frame
	main_ui = get_tree().get_first_node_in_group("main_ui")
	card_rewards_menu = get_tree().get_first_node_in_group("card_rewards_menu")
	projects_manager = get_tree().get_first_node_in_group("projects_manager")
	hours_tracker = get_tree().get_first_node_in_group("hours_tracker")
	
	score = 0
	stress_accumulation = 0
	hours = STARTING_HOURS
	stress = 4
	day = 1
	promise_queue = CardsController.promise_queue
	
	await get_tree().create_timer(.2).timeout
	for i in range(0,4):
		var resource := await projects_manager.get_project_resource(i)
		projects_manager._create_project(resource, i)
		
	await CardsController.enqueue_create_cards(card_data_debug)
	await CardsController.enqueue_shuffle_deck()
	CardsController.enqueue_draw_multiple_cards(5)
	receiving_input = true
	
func go_to_next_day() -> void:
	receiving_input = false
	hours_tracker.big_arrow_enabled = false
	await CardsController.enqueue_discard_all_cards_from_hand()
	await _set_stress_accumulation(stress_accumulation + stress)
	day += 1
	main_ui.set_score_label(score)
	
	if main_ui.check_game_over():
		return
	hours = STARTING_HOURS
	SignalBus.new_day_started.emit(day)
	receiving_input = true
	CardsController.enqueue_draw_multiple_cards(5)
	get_tree().create_timer(2.2).timeout.connect(func(): hours_tracker.big_arrow_enabled = true)
	
func _set_stress_accumulation(value: int):
	stress_accumulation = value
	while true:
		if stress_accumulation < MAX_STRESS_ACCUMULATION:
			await main_ui.set_stress_accumulation_bar(stress_accumulation)
			return
		
		await main_ui.set_stress_accumulation_bar(MAX_STRESS_ACCUMULATION)
		main_ui.reset_stress_accumulation_bar()
		await card_rewards_menu.add_random_obstacle_card_to_deck()
		stress_accumulation = stress_accumulation - MAX_STRESS_ACCUMULATION
		
func check_win() -> bool:
	if score >= main_ui.deadlines[main_ui.deadlines.size()-1].target_score:
		get_tree().change_scene_to_file("res://ui/win_screen_menu/win_screen.tscn")
		return true
	return false

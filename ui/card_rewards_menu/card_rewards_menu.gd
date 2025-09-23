class_name CardRewardsMenu
extends Control

const NUM_CARD_CHOICES = 3

@export var cards_hbox_container: HBoxContainer
@export var skip_button: Button

var logic_card_resources_pool = FolderOperations.load_resources_from_folder("res://card/card_data/cards/logic/")
var creativity_card_resources_pool := FolderOperations.load_resources_from_folder("res://card/card_data/cards/creativity/")
var wisdom_card_resources_pool := FolderOperations.load_resources_from_folder("res://card/card_data/cards/wisdom/")
var obstacle_card_resources_pool := FolderOperations.load_resources_from_folder("res://card/card_data/cards/obstacle/")
var curr_choices: Array[Card]
	
func _process(delta: float) -> void:
	if !visible:
		return
	if !Input.is_action_just_pressed("click"):
		return
	var mouse_pos = get_viewport().get_mouse_position()
	print(mouse_pos)
	for card in curr_choices:
		if mouse_pos.y > card.panel.global_position.y && \
				mouse_pos.y < card.panel.global_position.y + card.panel.size.y && \
				mouse_pos.x > card.panel.global_position.x && \
				mouse_pos.x < card.panel.global_position.x + card.panel.size.x:
			card_picked(card)
			return
	
func add_random_obstacle_card_to_deck() -> void:
	var pick = obstacle_card_resources_pool[randi() % obstacle_card_resources_pool.size()]
	var card = Card.create_card(pick)
	await CardsController._create_card(card.card_data, Vector2(580,200), 2.0)

func create_card_preview(card_data: CardData) -> Card:
	return Card.create_card(card_data)

func preview_cards(project_type: ProjectResource.project_type):
	CardsController.pause_queue()
	
	var pool: Array[Resource]
	match project_type:
		ProjectResource.project_type.LOGIC:
			pool = logic_card_resources_pool
		ProjectResource.project_type.CREATIVITY:
			pool = creativity_card_resources_pool
		ProjectResource.project_type.WISDOM:
			pool = wisdom_card_resources_pool
			
	var picks : Array[int] = []
	for i in range (0, NUM_CARD_CHOICES):
		var pick : int
		while picks.has(pick):
			pick = randi() % pool.size()
		picks.append(pick)
		var card_preview = create_card_preview(pool[pick])
		card_preview.state = Card.states.PREVIEW_PICKING
		cards_hbox_container.add_child(card_preview)
		curr_choices.append(card_preview)
	visible = true

## Ends the card selection with a choice.
## card: the chosen card being added to the deck. If null, skip was chosen.
func card_picked(card: Card):
	visible = false
	if card != null:
		await CardsController._create_card(card.card_data, card.global_position)
		await CardsController._shuffle_deck()
	CardsController.unpause_queue()
	
	curr_choices.clear()
	for child in cards_hbox_container.get_children():
		child.queue_free()

func _ready() -> void:
	visible = false
	skip_button.focus_mode = FOCUS_NONE

func _on_skip_button_pressed() -> void:
	card_picked(null)

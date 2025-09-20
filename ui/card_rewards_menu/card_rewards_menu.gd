class_name CardRewardsMenu
extends Control

const NUM_CARD_CHOICES = 3

@export var cards_hbox_container: HBoxContainer

var logic_card_resources_pool = FolderOperations.load_resources_from_folder("res://card/card_data/cards/logic/")
var creativity_card_resources_pool := FolderOperations.load_resources_from_folder("res://card/card_data/cards/creativity/")
var wisdom_card_resources_pool := FolderOperations.load_resources_from_folder("res://card/card_data/cards/wisdom/")
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
			
	for i in range (0, NUM_CARD_CHOICES):
		var pick = pool[randi() % pool.size()]
		var card_preview = create_card_preview(pick)
		card_preview.state = Card.states.PREVIEW_PICKING
		cards_hbox_container.add_child(card_preview)
		curr_choices.append(card_preview)
	visible = true

func card_picked(card: Card):
	visible = false
	CardsController._create_card(card.card_data, card.global_position)
	CardsController.unpause_queue()
	
	curr_choices.clear()
	for child in cards_hbox_container.get_children():
		child.queue_free()

func _ready() -> void:
	visible = false

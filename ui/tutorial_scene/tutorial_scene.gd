class_name TutorialScene
extends Control

@export var left_arrow: TextureRect
@export var left_arrow_button: Button
@export var right_arrow: TextureRect
@export var right_arrow_button: Button

@export var start_button: Button

@export var pages: Array[Control]

var page : int :
	set(value):
		page = value
		
		for page in pages:
			page.visible = false
		pages[page].visible = true
		
		if page == 0:
			left_arrow.visible = false
		else:
			left_arrow.visible = true
		if page == pages.size() - 1:
			right_arrow.visible = false
			start_button.visible = true
		else:
			right_arrow.visible = true
			start_button.visible = false
			
func _ready():
	left_arrow_button.focus_mode = Control.FOCUS_NONE
	right_arrow_button.focus_mode = Control.FOCUS_NONE
	start_button.focus_mode = Control.FOCUS_NONE
	page = 0

func _on_left_arrow_button_pressed() -> void:
	page -= 1

func _on_right_arrow_button_pressed() -> void:
	page += 1

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")

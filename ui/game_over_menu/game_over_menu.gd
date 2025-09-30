class_name GameOverMenu
extends Control

@export var day_label : Label
@export var score_label : Label
@export var retry_button : Button
@export var main_menu_button : Button
@export var cursor : Cursor

func _ready() -> void:
	retry_button.focus_mode = FOCUS_NONE
	day_label.text = "Made it to: Day " + str(GameManager.day - 1)
	score_label.text = "Score: " + str(GameManager.score)

func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")

func _on_retry_button_mouse_entered() -> void:
	SignalBus.node_hovered.emit(retry_button)

func _on_retry_button_mouse_exited() -> void:
	SignalBus.node_stop_hovered.emit(retry_button)

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")

func _on_main_menu_button_mouse_entered() -> void:
	SignalBus.node_hovered.emit(main_menu_button)

func _on_main_menu_button_mouse_exited() -> void:
	SignalBus.node_stop_hovered.emit(main_menu_button)

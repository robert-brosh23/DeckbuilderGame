class_name WinScreenMenu
extends Control

@export var day_label : Label
@export var score_label : Label
@export var main_menu_button : Button
@export var cursor : Cursor

func _ready() -> void:
	main_menu_button.focus_mode = FOCUS_NONE
	day_label.text = "Completed at: Day " + str(GameManager.day)
	score_label.text = "Score: " + str(GameManager.score)

func _on_main_menu_button_mouse_entered() -> void:
	SignalBus.node_hovered.emit(main_menu_button)

func _on_main_menu_button_mouse_exited() -> void:
	SignalBus.node_stop_hovered.emit(main_menu_button)

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")

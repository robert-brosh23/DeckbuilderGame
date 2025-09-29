extends Control

@export var day_label : Label
@export var score_label : Label
@export var retry_button : Button
@export var cursor : Cursor

func _ready() -> void:
	day_label.text = "Made it to: Day " + str(GameManager.day)
	score_label.text = "Score: " + str(GameManager.score)

func _on_retry_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")

func _on_retry_button_mouse_entered() -> void:
	SignalBus.node_hovered.emit(retry_button)

func _on_retry_button_mouse_exited() -> void:
	SignalBus.node_stop_hovered.emit(retry_button)

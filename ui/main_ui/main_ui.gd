class_name MainUi
extends Control

@onready var hours_label := $MarginContainer/VBoxContainer2/HBoxContainer2/HoursLabel
@onready var mental_health_bar = $MarginContainer/VBoxContainer2/MentalHealthBar
@onready var day_label := $"MarginContainer/VBoxContainer2/HBoxContainer3/Day Label"
@onready var score_label := $MarginContainer/VBoxContainer2/ScoreLabel
@export var end_day_button : Button

func _ready() -> void:
	end_day_button.focus_mode = FOCUS_NONE

func set_hours_label(hours: int):
	hours_label.text = "Hours: " + str(hours)
	
func set_mental_health_bar_value(value: int):
	mental_health_bar.value = value

func set_day_label(day: int):
	day_label.text = "Day : " + str(day)
	
func set_score_label(score: int):
	score_label.text = "Score : " + str(score)

func _on_end_day_button_pressed() -> void:
	if !CardsController.receiving_input():
		return
	GameManager.go_to_next_day()

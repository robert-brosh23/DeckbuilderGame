class_name MainUi
extends Control

@onready var hours_label := $MarginContainer/VBoxContainer2/HBoxContainer2/HoursLabel
@onready var mental_health_bar = $MarginContainer/VBoxContainer2/HBoxContainer/ProgressBar
@onready var day_label := $"MarginContainer/VBoxContainer2/HBoxContainer3/Day Label"

func set_hours_label(hours: int):
	hours_label.text = "Hours remaining: " + str(hours)
	
func set_mental_health_bar_value(value: int):
	mental_health_bar.value = value

func set_day_label(day: int):
	day_label.text = "Day : " + str(day)

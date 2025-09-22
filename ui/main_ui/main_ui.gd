class_name MainUi
extends Control

@onready var hours_label := $MarginContainer/VBoxContainer2/HBoxContainer2/HoursLabel
@onready var stress_label := $MarginContainer/VBoxContainer2/HBoxContainer/StressLabel
@onready var stress_accumulation_bar : ProgressBar = $MarginContainer/VBoxContainer2/StressAccumulationBar
@onready var day_label := $"MarginContainer/VBoxContainer2/HBoxContainer3/Day Label"
@onready var score_label := $MarginContainer/VBoxContainer2/ScoreLabel
@export var end_day_button : Button

var shake_stress_label = false

func _ready() -> void:
	end_day_button.focus_mode = FOCUS_NONE
	stress_accumulation_bar.max_value = GameManager.MAX_STRESS
	stress_accumulation_bar.value = 0

func set_hours_label(hours: int):
	hours_label.text = "Hours: " + str(hours)
	
func set_stress_label(stress: int):
	var text = "Stress: "
	if shake_stress_label:
		text += "[color=#ab5675][shake rate=25.0 level=15 connected=1]" + str(stress) + "[/shake][/color]"
	else:
		text += str(stress)
	text += "/" + str(GameManager.MAX_STRESS)
	stress_label.text = text
	
func set_stress_accumulation_bar(target_value: int):
	shake_stress_label = true
	set_stress_label(GameManager.stress)
	var curr_value := stress_accumulation_bar.value
	while curr_value != target_value:
		curr_value += 1
		await _tween_progress_bar(stress_accumulation_bar, curr_value, .5)
	shake_stress_label = false
	set_stress_label(GameManager.stress)
		
func reset_stress_accumulation_bar():
	shake_stress_label = true
	set_stress_label(GameManager.stress)
	await _tween_progress_bar(stress_accumulation_bar, 0, 1.0)
	shake_stress_label = false
	set_stress_label(GameManager.stress)

func set_day_label(day: int):
	day_label.text = "Day : " + str(day)
	
func set_score_label(score: int):
	score_label.text = "Score : " + str(score)

func _on_end_day_button_pressed() -> void:
	if !CardsController.receiving_input():
		return
	GameManager.go_to_next_day()
	
func _tween_progress_bar(bar: ProgressBar, new_value: float, duration: float = 0.5) -> void:
	var tween := get_tree().create_tween()
	await tween.tween_property(bar, "value", new_value, duration).set_trans(Tween.TRANS_LINEAR).finished

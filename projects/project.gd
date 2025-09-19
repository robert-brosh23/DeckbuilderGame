extends Control
class_name Project

signal projectFinished
signal projectStarted

@export var template: ProjectResource

@onready var panel_container := $VBoxContainer/MarginContainer/PanelContainer
@onready var title_text := $VBoxContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/TitleText
@onready var progress_bar := $VBoxContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ProgressBar
@onready var targetable_indicator := $TargetableIndicator
@onready var animation_player := $AnimationPlayer
@onready var step_container := $VBoxContainer/StepContainer

var step_png := preload("res://sprites/step.png")
var steps := 0

var current_progress = 0
var targetable := false
var active := false
var main_ui : MainUi


static func create_project(template: ProjectResource):
	var instance = preload("res://projects/project.tscn").instantiate()
	instance.init(template)

func init(template: ProjectResource):
	animation_player.play("spawn_project")
	self.template = template
	title_text.text = template.displayName + "\n(" + str(template.targetProgress) + " left)"
	progress_bar.max_value = template.targetProgress
	progress_bar.value = 0
	current_progress = 0
	_clear_steps()
	_toggle_fill_bar_border_right(false)
	
	var color: String
	match template.type:
		ProjectResource.project_type.LOGIC: 
			color = Constants.COLOR_BLUE
		ProjectResource.project_type.CREATIVITY:
			color = Constants.COLOR_YELLOW
		ProjectResource.project_type.WISDOM:
			color = Constants.COLOR_HOT_PINK
	_apply_stylebox(color)
	active = true
	projectStarted.emit()
	
func progress(progress_amount: int):
	current_progress = clamp(current_progress + progress_amount, 0, template.targetProgress)
	progress_bar.set_value(current_progress)
	title_text.text = template.displayName + "\n(" + str(template.targetProgress - current_progress) + " left)"
	if current_progress == template.targetProgress:
		_project_completed()
		
func check_targetable(conditions: Array[Callable]):
	if current_progress == template.targetProgress || !active:
		return
	for condition in conditions:
		if condition.call() == false:
			return
			
	_show_targetable()
		
func _project_completed():
	_toggle_fill_bar_border_right(true)
	
	GameManager.score += template.targetProgress * GameManager.mental_health
	main_ui.set_score_label(GameManager.score)
	print("project ", template.displayName, " completed.")
	animation_player.play("destroy_project")
	active = false
	projectFinished.emit()
	
func _toggle_fill_bar_border_right(present: bool):
	var sb := progress_bar.get("theme_override_styles/fill") as StyleBoxFlat
	var copy := sb.duplicate() as StyleBoxFlat
	if present:
		copy.border_width_right = 1
	else:
		copy.border_width_right = 0
	progress_bar.add_theme_stylebox_override("fill", copy)
	
func _apply_stylebox(panel_color: String):
	var sb := panel_container.get("theme_override_styles/panel") as StyleBoxFlat
	if sb:
		var copy := sb.duplicate() as StyleBoxFlat
		copy.bg_color = panel_color
		panel_container.add_theme_stylebox_override("panel", copy)
	if panel_color == Constants.COLOR_YELLOW:
		title_text.add_theme_color_override("font_color", Constants.COLOR_PURPLE)

func _show_targetable():
	targetable = true
	targetable_indicator.visible = true
	
func hide_targetable():
	targetable = false
	targetable_indicator.visible = false
	
func add_step_and_progress() -> void:
	var text_rect := TextureRect.new()
	text_rect.texture = step_png
	step_container.add_child(text_rect)
	
	steps += 1
	progress(steps)
	
func _clear_steps() -> void:
	steps = 0
	for child in step_container.get_children():
		step_container.remove_child(child)
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init(template)
	main_ui = get_tree().get_first_node_in_group("main_ui")

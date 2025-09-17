extends Control
class_name Project

signal projectFinished

@export var template: ProjectResource

@onready var panel_container := $MarginContainer/PanelContainer
@onready var title_text := $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/TitleText
@onready var progress_bar := $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ProgressBar
@onready var targetable_indicator := $TargetableIndicator

var current_progress = 0
var targetable := false
var main_ui : MainUi

static func create_project(template: ProjectResource):
	var instance = preload("res://projects/project.tscn").instantiate()
	instance.init(template)

func init(template: ProjectResource):
	self.template = template
	title_text.text = template.displayName + "\n(" + str(template.targetProgress) + " left)"
	progress_bar.max_value = template.targetProgress
	progress_bar.value = 0
	var color: String
	match template.type:
		ProjectResource.project_type.LOGIC: 
			color = Constants.COLOR_BLUE
		ProjectResource.project_type.CREATIVITY:
			color = Constants.COLOR_YELLOW
		ProjectResource.project_type.WISDOM:
			color = Constants.COLOR_HOT_PINK
	_apply_stylebox(color)
	
func progress(progress_amount: int):
	current_progress = clamp(current_progress + progress_amount, 0, template.targetProgress)
	progress_bar.set_value(current_progress)
	title_text.text = template.displayName + "\n(" + str(template.targetProgress - current_progress) + " left)"
	if current_progress == template.targetProgress:
		_project_completed()
		
func check_targetable(conditions: Array[Callable]):
	if current_progress == template.targetProgress:
		return
	for condition in conditions:
		if condition.call() == false:
			return
			
	_show_targetable()
		
func _project_completed():
	var sb := progress_bar.get("theme_override_styles/fill") as StyleBoxFlat
	if sb:
		var copy := sb.duplicate() as StyleBoxFlat
		copy.border_width_right = 1
		progress_bar.add_theme_stylebox_override("fill", copy)
	
	GameManager.score += template.targetProgress * GameManager.mental_health
	main_ui.set_score_label(GameManager.score)
	print("project ", template.displayName, " completed.")
	
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
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init(template)
	main_ui = get_tree().get_first_node_in_group("main_ui")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

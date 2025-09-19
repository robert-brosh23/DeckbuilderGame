class_name ProjectsManager extends Control

@export var projects: Array[Project]
@export var full_area_target_indicator: ColorRect

var full_area_targeted: bool = false:
	set(value):
		full_area_targeted = value
		if value == true:
			full_area_target_indicator.visible = true
		else:
			full_area_target_indicator.visible = false


func _ready() -> void:
	call_deferred("_connect_signals")
	
func check_mouse_in_area(mouse_pos: Vector2) -> bool:
	if mouse_pos.y > full_area_target_indicator.global_position.y && \
			mouse_pos.y < full_area_target_indicator.global_position.y + full_area_target_indicator.size.y && \
			mouse_pos.x > full_area_target_indicator.global_position.x && \
			mouse_pos.x < full_area_target_indicator.global_position.x + full_area_target_indicator.size.x:
		return true
	return false
	
func enable_full_area_target() -> void:
	full_area_targeted = true
	
func disable_full_area_target() -> void:
	full_area_targeted = false
	
func _connect_signals():
	for project in projects:
		project.projectFinished.connect(_project_finished.bind(project))

func _project_finished(project: Project):
	await get_tree().create_timer(1.0).timeout
	var template = ProjectResource.new()
	
	#test template
	template.displayName = "asdf"
	template.type = ProjectResource.project_type.CREATIVITY
	template.targetProgress = 20
	
	project.init(template)

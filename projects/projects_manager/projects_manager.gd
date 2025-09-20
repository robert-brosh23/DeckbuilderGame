class_name ProjectsManager extends Control

@export var debug_project_templates: Array[ProjectResource]
@export var project_grid_container: GridContainer

var card_rewards_menu: CardRewardsMenu
var project_scene = preload("res://projects/project.tscn")
var projects : Array[Project] = []

var project_resources_pool := FolderOperations.load_resources_from_folder("res://projects/project_data/projects/")

var full_area_targeted: bool = false:
	set(value):
		full_area_targeted = value
		if value == true:
			var stylebox = StyleBoxFlat.new()
			stylebox.bg_color = Constants.COLOR_LIGHT_PINK
			add_theme_stylebox_override("panel", stylebox)
		else:
			var stylebox = StyleBoxFlat.new()
			stylebox.bg_color = "ffa7a500"
			add_theme_stylebox_override("panel", stylebox)


func _ready() -> void:
	card_rewards_menu = get_tree().get_first_node_in_group("card_rewards_menu")
	for project_template in debug_project_templates:
		_create_project(project_template)
	
func check_mouse_in_area(mouse_pos: Vector2) -> bool:
	if mouse_pos.y > global_position.y && \
			mouse_pos.y < global_position.y + size.y && \
			mouse_pos.x > global_position.x && \
			mouse_pos.x < global_position.x + size.x:
		return true
	return false
	
func enable_full_area_target() -> void:
	full_area_targeted = true
	
func disable_full_area_target() -> void:
	full_area_targeted = false
	
func _create_project(template: ProjectResource) -> Project:
	var project = Project.create_project(template)
	project.projectFinished.connect(_project_finished.bind(project))
	project_grid_container.add_child(project)
	projects.append(project)
	return project

func _project_finished(project: Project):
	projects.erase(project)
	project.queue_free()
	
	card_rewards_menu.preview_cards(project.template.type)
	
	await get_tree().create_timer(1.0).timeout
	
	
	var new_project_resource
	while new_project_resource is not ProjectResource:
		if project_resources_pool.is_empty():
			print("out of projects")
			return
		new_project_resource = project_resources_pool[randi() % project_resources_pool.size()]
		project_resources_pool.erase(new_project_resource)
	
	
	_create_project(new_project_resource)
		

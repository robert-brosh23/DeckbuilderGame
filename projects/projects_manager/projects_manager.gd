class_name ProjectsManager extends Control

@export var projects: Array[Project]

func _ready() -> void:
	call_deferred("_connect_signals")
	
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

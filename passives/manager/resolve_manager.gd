class_name ResolveManager
extends Control

@export var hbox_container: HBoxContainer

@export var debug_resolve: ResolveData

@export var preloader: ResourcePreloader

var resolve_pool : Array[Resource] = []

func _ready():
	resolve_pool = _load_resolves(preloader)

func get_random_resolve_data() -> ResolveData:
	return resolve_pool[randi() % resolve_pool.size()]
	
func add_resolve(resolve_data: ResolveData):
	var new_resolve = Resolve.create_resolve(resolve_data.duplicate(true))
	hbox_container.add_child(new_resolve)

func _load_resolves(preloader: ResourcePreloader) -> Array[Resource]:
	var arr : Array[Resource] = []
	for resource in preloader.get_resource_list():
		arr.append(preloader.get_resource(resource))
	return arr

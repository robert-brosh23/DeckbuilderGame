class_name FolderOperations
extends Node

static func load_resources_from_folder(folder_path: String, extensions: Array = [".tres"]) -> Array[Resource]:
	var dir := DirAccess.open(folder_path)
	if dir == null:
		push_error("Could not open folder: %s" % folder_path)
		return []

	var resources: Array[Resource] = []
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir():
			for ext in extensions:
				if file_name.ends_with(ext):
					var res_path = folder_path.path_join(file_name)
					var res = load(res_path)
					if res != null:
						resources.append(res)
		file_name = dir.get_next()
	dir.list_dir_end()

	return resources

static func get_random_resource_from_folder(folder_path: String, extensions: Array = [".tres"]) -> Resource:
	var dir := DirAccess.open(folder_path)
	if dir == null:
		push_error("Could not open folder: %s" % folder_path)
		return null

	var files: Array[String] = []
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir():
			for ext in extensions:
				if file_name.ends_with(ext):
					files.append(file_name)
		file_name = dir.get_next()
	dir.list_dir_end()

	if files.is_empty():
		push_warning("No resources found in %s" % folder_path)
		return null

	var pick = files[randi() % files.size()]
	return load(folder_path.path_join(pick))

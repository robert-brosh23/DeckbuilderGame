class_name ResolvePreview extends Control

@export var texture : TextureRect
@export var description_label : Label

var resolve_data : ResolveData
var hovering := false

static func create_resolve_preview(data: ResolveData) -> ResolvePreview:
	var instance : ResolvePreview = preload("res://passives/preview/ResolvePreview.tscn").instantiate()
	instance.init(data)
	return instance

func init(data: ResolveData):
	texture.texture = data.texture_png
	description_label.text = data.resolve_name + ": " + data.tooltip
	resolve_data = data

func _on_panel_container_mouse_entered() -> void:
	hovering = true

func _on_panel_container_mouse_exited() -> void:
	hovering = false

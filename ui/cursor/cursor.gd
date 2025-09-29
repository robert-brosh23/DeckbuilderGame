class_name Cursor
extends Node2D

@export var regular : Sprite2D
@export var pointer : Sprite2D

var hovering_nodes : Array[Node] = []

func _ready():
	pointer.visible = false
	regular.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	SignalBus.node_hovered.connect(_add_hovering_node)
	SignalBus.node_stop_hovered.connect(_remove_hovering_node)
	
func _process(delta: float) -> void:
	global_position = get_global_mouse_position()
	if hovering_nodes.is_empty():
		_stop_use_pointer()
	else:
		_use_pointer()
	
func _add_hovering_node(node: Node):
	hovering_nodes.append(node)
	
func _remove_hovering_node(node: Node):
	hovering_nodes.erase(node)
	
func _use_pointer():
	pointer.visible = true
	regular.visible = false

func _stop_use_pointer():
	pointer.visible = false
	regular.visible = true
	

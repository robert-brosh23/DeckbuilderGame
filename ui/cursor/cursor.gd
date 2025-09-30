class_name Cursor
extends Node2D

@export var regular : Sprite2D
@export var pointer : Sprite2D
@export var message_label : MessageLabel

var message_queue : Array[String]
var is_processing := false

var hovering_nodes : Array[Node] = []


func play_message(message: String):
	message_queue.append(message)
	if not is_processing:
		_process_queue()

func _process_queue() -> void:
	is_processing = true
	while message_queue.size() > 0:
		var msg = message_queue.pop_front()
		var message_label = MessageLabel.create_message_label()
		add_child(message_label)
		message_label.play_message_animation(msg)
		await get_tree().create_timer(1.0).timeout
	is_processing = false


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
	

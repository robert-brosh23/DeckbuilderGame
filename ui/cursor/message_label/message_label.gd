class_name MessageLabel
extends Control

@export var message_label : Label

static func create_message_label() -> MessageLabel:
	return preload("res://ui/cursor/message_label/message_label.tscn").instantiate()
	
func play_message_animation(message: String) -> void:
	message_label.text = message
	var color = Constants.COLOR_BROWN
	var delay_time = 0.3
	
	var move_tween = get_tree().create_tween()
	move_tween.finished.connect(func(): queue_free())
	move_tween.set_ease(Tween.EASE_IN)
	var position = Vector2(message_label.position.x, message_label.position.y - 20)
	var move_time = 1.5
	
	move_tween.tween_property(message_label, "position", position, move_time)	

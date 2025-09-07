class_name MovementTweenManager
extends Node


func tween_to_pos(node: Node, pos: Vector2, seconds: float = 1.0) -> void:
	var tween = create_tween()
	tween.tween_property(node, "position", pos, seconds * Globals.animation_speed_scale)

func tween_visible(node: Node, visible: bool, seconds: float = 1.0) -> void:
	var tween = create_tween()
	tween.tween_callback(func():
		node.visible = visible
	).set_delay(seconds * Globals.animation_speed_scale)

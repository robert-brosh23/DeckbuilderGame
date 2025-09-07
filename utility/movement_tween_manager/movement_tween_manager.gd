class_name MovementTweenManager
extends Node


func tween_to_pos(node: Node, pos: Vector2, seconds: float = 1.0) -> Tween:
	var tween = create_tween()
	tween.tween_property(node, "position", pos, seconds * Globals.animation_speed_scale)
	return tween

func tween_visible(node: Node, visible: bool, seconds: float = 1.0) -> Tween:
	var tween = create_tween()
	tween.tween_callback(func():
		node.visible = visible
	).set_delay(seconds * Globals.animation_speed_scale)
	return tween

func tween_delay(callable: Callable, seconds:float = 1.0) -> Tween:
	var tween = create_tween()
	tween.tween_interval(seconds * Globals.animation_speed_scale)
	tween.tween_callback(callable)
	return tween

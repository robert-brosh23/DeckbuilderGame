class_name MovementTweenManager
extends Node

var pos_tween : Tween

func tween_to_pos(node: Node, pos: Vector2, seconds: float = 1.0) -> Tween:
	if pos_tween != null:
		pos_tween.kill()
	pos_tween = create_tween()
	pos_tween.tween_property(node, "position", pos, seconds * Globals.animation_speed_scale)
	return pos_tween

func tween_delay(callable: Callable, seconds:float = 1.0) -> Tween:
	var tween = create_tween()
	tween.tween_interval(seconds * Globals.animation_speed_scale)
	tween.tween_callback(callable)
	return tween

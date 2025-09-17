class_name PromiseQueue
extends Node

class Promise:
	var callable: Callable
	signal result_signal

	static func create_promise(callable: Callable) -> Promise:
		var promise = Promise.new()
		promise.callable = callable
		return promise


var queue: Array[Promise] = []
var processing := false
var tree := Engine.get_main_loop() as SceneTree

func enqueue(func_ref: Callable) -> Signal:
	var promise = Promise.create_promise(func_ref)
	queue.append(promise)
	if !processing:
		processing = true
		call_deferred("_process_queue")
	return promise.result_signal
	
func enqueue_delay(seconds: float):
	enqueue(func(): await tree.create_timer(seconds * Globals.animation_speed_scale).timeout)
	
func _process_queue() -> void:
	while !queue.is_empty():
		var item: Promise = queue.pop_front()
		var fn: Callable = item.callable
		var result_signal = item.result_signal
		
		var result = await fn.call()
		result_signal.emit(result)
	processing = false

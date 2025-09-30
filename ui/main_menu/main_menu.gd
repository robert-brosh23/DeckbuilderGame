class_name MainMenu extends Control

@export var cursor: Cursor

@export var start_button: Button
@export var options_button: Button
@export var credits_button: Button
@export var credits_return_to_main_button: Button
@export var options_return_to_main_button: Button

@export var main_menu_screen: Control
@export var credits_menu_screen: MarginContainer
@export var options_menu_screen: MarginContainer

var song := preload("res://audio/music/game_jam_song_clippeed.mp3")

func _ready() -> void:
	start_button.focus_mode = FOCUS_NONE
	options_button.focus_mode = FOCUS_NONE
	credits_button.focus_mode = FOCUS_NONE
	credits_return_to_main_button.focus_mode = FOCUS_NONE
	
	AudioPlayer.reset()
	AudioPlayer.play_sound(song, false, AudioPlayer.Bus.MUSIC, true)
	
	main_menu_screen.visible = true
	credits_menu_screen.visible = false
	
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
	
func _on_credits_pressed() -> void:
	main_menu_screen.visible = false
	credits_menu_screen.visible = true

func _on_credits_return_to_main_pressed() -> void:
	main_menu_screen.visible = true
	credits_menu_screen.visible = false

func _on_options_pressed() -> void:
	main_menu_screen.visible = false
	options_menu_screen.visible = true
	
func _on_options_return_to_main_pressed() -> void:
	main_menu_screen.visible = true
	options_menu_screen.visible = false


func _on_start_button_mouse_entered() -> void:
	SignalBus.node_hovered.emit(start_button)


func _on_start_button_mouse_exited() -> void:
	SignalBus.node_stop_hovered.emit(start_button)


func _on_options_mouse_entered() -> void:
	SignalBus.node_hovered.emit(options_button)


func _on_options_mouse_exited() -> void:
	SignalBus.node_stop_hovered.emit(options_button)


func _on_credits_mouse_entered() -> void:
	SignalBus.node_hovered.emit(credits_button)


func _on_credits_mouse_exited() -> void:
	SignalBus.node_stop_hovered.emit(credits_button)


func _on_credits_return_to_main_mouse_entered() -> void:
	SignalBus.node_hovered.emit(credits_return_to_main_button)


func _on_credits_return_to_main_mouse_exited() -> void:
	SignalBus.node_stop_hovered.emit(credits_return_to_main_button)


func _on_options_return_to_main_mouse_entered() -> void:
	SignalBus.node_hovered.emit(options_return_to_main_button)


func _on_options_return_to_main_mouse_exited() -> void:
	SignalBus.node_stop_hovered.emit(options_return_to_main_button)

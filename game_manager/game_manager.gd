class_name GameManager
extends Node2D

@onready var hours_label := $HoursLabel

var hours: int:
	set(value):
		hours = value
		hours_label.text = "Hours remaining: " + str(self.hours)

func _ready() -> void:
	hours = 8
	

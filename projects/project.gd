extends Control
class_name Project

signal projectFinished

@export var type: String
var targetProgress : int
var currentProgress = 0

func init(template: Project_Resource):
	targetProgress = template.targetProgress;
	$RichTextLabel.add_text(template.displayName)
	$ProgressBar.set_max(template.targetProgress)
	type = template.type
	var color
	match type:
		'tech': 
			color = Color.CORNFLOWER_BLUE
		'art':
			color = Color.AQUAMARINE
		'wisdom':
			color = Color.HOT_PINK
	$Background.set_color(color)
	
	
func progress(progress_amount: int):
	currentProgress += progress_amount
	$ProgressBar.set_value(currentProgress)
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

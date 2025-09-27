class_name ProjectResource
extends Resource

@export var displayName: String

@export var type: project_type

@export var targetProgress: int

enum project_type {
	LOGIC,
	CREATIVITY,
	WISDOM,
	OBSTACLE
}

## add a bunch of stuff here for rewards, etc

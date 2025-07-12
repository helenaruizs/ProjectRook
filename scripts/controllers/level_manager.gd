class_name LevelManager

extends Node

@export var initial_level: PackedScene
@export var all_levels: Dictionary[Enums.Levels, PackedScene]
@export var stage: Stage

var current_level: Node = null

func _ready() -> void:
	load_level(Enums.Levels.LEVEL_0)

func load_level(new_level: Enums.Levels) -> void:
	if current_level:
		current_level.queue_free()
	var level_to_load: PackedScene = all_levels.get(new_level, null)
	current_level = level_to_load.instantiate()
	stage.add_child(current_level)
	# TODO: Add functionality to reset game manager, etc.

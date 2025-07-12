class_name SpawnMarker

extends Node3D

@onready var sprite_preview: Sprite3D = $Sprite3D

@export var spawn_piece: PieceResource
var board_pos: Vector2i

func _ready() -> void:
	sprite_preview.visible = false

# Functions
# TODO: Function to grab the board position

class_name PieceResource

extends Resource

@export var piece_data: PieceBasicData
@export var movement_data: MovementData

var piece_scene: PackedScene

func _ready() -> void:
	piece_scene = Refs.piece_base_scn

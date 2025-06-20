class_name MovementComponent

extends Node

var piece : Piece
var grid_pos : Vector2i

func _ready() -> void:
	await owner
	piece = owner
	grid_pos = piece.board_pos


func scan_legal_tiles() -> Array:
	var tiles := []
	return tiles


func move_piece(from_pos: Vector2i, to_pos: Vector3) -> void:
	pass

extends Node


## HACK hardcoded references
const PIECE = preload("res://scenes/pieces/base_pieces/piece.tscn")
#
## Scene references
@export var board : Board
@export var player_pieces : FactionPieces
@export var enemy_pieces : FactionPieces
@export var camera : Camera3D
@export var ui : Control
#
#var current_turn : GameTurn = GameTurn.PLAYER
#var board_map : Dictionary = {} 

func _ready() -> void:
	await board.ready
	var grid_position := Vector2i(3,-3)
	var test_tile : Vector3 = board.get_grid_position(grid_position.x, grid_position.y)
	var test_piece := PIECE.instantiate()
	test_piece.board_pos = grid_position
	player_pieces.add_child(test_piece)
	test_piece.global_position = test_tile
	print(test_tile)

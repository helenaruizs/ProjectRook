extends Node

enum GameTurn {
	PLAYER,
	ENEMY,
}

# HACK hardcoded references
const PIECE = preload("res://scenes/pieces/base_pieces/piece.tscn")

# Scene references
@export var board : Board
@export var player_pieces : FactionPieces
@export var enemy_pieces : FactionPieces
@export var camera : Camera3D
@export var ui : Control

var current_turn : GameTurn = GameTurn.PLAYER
var board_map : Dictionary = {} 

#func _ready():
	#await board.ready
	#var test_tile = board.get_position_by_id("D4")
	#var test_piece = PIECE.instantiate()
	#test_piece.board_pos = "D4"
	#player_pieces.add_child(test_piece)
	#test_piece.global_transform.origin = test_tile

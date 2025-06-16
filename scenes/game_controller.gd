extends Node

enum GameTurn {
	PLAYER,
	ENEMY,
}

# Scene references
@export var board : Board
@export var player_pieces : FactionPieces
@export var enemy_pieces : FactionPieces
@export var camera : Camera3D
@export var ui : Control

var current_turn : GameTurn = GameTurn.PLAYER
var board_map : Dictionary = {} 

func _ready():
	await board.ready
	var test_tile = board.get_position_by_id("A4")
	print(test_tile)

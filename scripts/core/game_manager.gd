class_name GameManager

extends Node

@export_subgroup("Basic Nodes Setup")
@export var board : Board
@export var player_container : FactionPieces
@export var enemy_container : FactionPieces
@export var camera : Camera3D
@export var ui : Control

@export_subgroup("Pieces")
@export_range(0, 64, 1) var player_piece_count : int = 16
@export_range(0, 64, 1) var enemy_piece_count : int = 16

@export var player_skin : PieceSkin
@export var enemy_skin : PieceSkin

#var current_turn : GameTurn = GameTurn.PLAYER
#var board_map : Dictionary = {} 

func _ready() -> void:
	pass

func _clear_board() -> void:
	# remove any existing children & reset board state
	player_container.clear()  # you’ll add a clear() method to FactionPieces
	enemy_container.clear()
	board.clear_all_pieces()  # add this to Board to wipe its piece_map


func _spawn_faction(
	count      : int,
	skin       : PieceSkin,
	container  : FactionPieces,
	is_enemy   : bool
) -> void:
	
	var cols: int = board.get_size()
	
	# Dealing with the 'facing' pieces, where the enemy starts as opposed to the player
	var row_start: int
	if is_enemy:
		row_start = board.BOARD_SIZE - 1
	else:
		row_start = 0

	var dir: int
	if is_enemy:
		dir = -1
	else:
		dir = 1

	var spawned := 0
	var r :int = row_start
	var c := 0
	while spawned < count:
		# instantiate the scene from the skin
		var scene = skin.scene.instantiate() as Piece
		container.add_child(scene)
		# set up its data
		scene.piece_stats.piece_type = skin.piece_type
		scene.modifiers.apply_skin(skin)       # or however you apply material
		scene.board_pos = Vector2i(c, r)
		board.register_piece(scene)            # board must place it in its piece_map
		# position in world
		scene.global_transform.origin = board.get_grid_position(c, r)

		spawned += 1
		c += 1
		if c >= cols:
			c = 0
			r += dir  # move inward toward the center

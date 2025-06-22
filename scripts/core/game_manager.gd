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

@export var player_skin : SkinResource.SkinNames
@export var enemy_skin : SkinResource.SkinNames

@export var player_faction : Enums.FactionColor = Enums.FactionColor.WHITE
@export var enemy_faction : Enums.FactionColor = Enums.FactionColor.BLACK

# ——— Editor‐tweakable piece‐order arrays ———
@export var pawn_row: Array[Enums.PieceType] = [
	Enums.PieceType.PAWN, Enums.PieceType.PAWN, Enums.PieceType.PAWN, Enums.PieceType.PAWN,
	Enums.PieceType.PAWN, Enums.PieceType.PAWN, Enums.PieceType.PAWN, Enums.PieceType.PAWN,
]
@export var back_row: Array[Enums.PieceType] = [
	Enums.PieceType.ROOK,   Enums.PieceType.KNIGHT, Enums.PieceType.BISHOP, Enums.PieceType.QUEEN,
	Enums.PieceType.KING,   Enums.PieceType.BISHOP, Enums.PieceType.KNIGHT, Enums.PieceType.ROOK,
]
# ————————————————————————

#var current_turn : GameTurn = GameTurn.PLAYER
#var board_map : Dictionary = {} 

func _ready() -> void:
	clear_board()

func clear_board() -> void:
	var placed_pieces: Array[Node] = get_tree().get_nodes_in_group("pieces")
	for piece_node in placed_pieces:
		if piece_node is Node:
			piece_node.queue_free()

func _spawn_faction(container: FactionPieces, is_enemy: bool) -> void:
	# Determine faction color
	var color: Enums.FactionColor
	if is_enemy:
		color = enemy_faction
	else:
		color = player_faction

	# Determine which row the pawns go on (front or back)
	var row0: int
	if is_enemy:
		row0 = board.BOARD_SIZE - 1
	else:
		row0 = 0

	# Determine the next row inward for the back-rank pieces
	var row1: int
	if is_enemy:
		row1 = row0 - 1
	else:
		row1 = row0 + 1

	# ... now use `color`, `row0`, and `row1` below ...
	for file in pawn_row.size():
		_spawn_one(pawn_row[file], color, container, file, row0)

	for file in back_row.size():
		_spawn_one(back_row[file], color, container, file, row1)
		
func _spawn_one(
	piece_type: Enums.PieceType,
	faction:   Enums.FactionColor,
	parent:    Node,
	file:      int,
	rank:      int
) -> void:
	# 1) Get the correct PackedScene from SkinManager
	var packed: PackedScene = SkinManager.get_piece_scene(piece_type)
	if packed == null:
		push_error("No scene for %s %s" % [piece_type])
		return

	# 2) Instance & add to the scene tree
	var piece : Node = packed.instantiate() as Piece
	parent.add_child(piece)

	# 3) Initialize piece data
	piece.piece_stats.piece_type  = piece_type
	piece.piece_stats.piece_color = faction

	# 4) Register with the Board’s map
	piece.board_pos = Vector2i(file, rank)
	board.register_piece(piece)

	# 5) Position in world
	piece.global_transform.origin = board.get_grid_position(file, rank)

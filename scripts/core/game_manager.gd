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
	spawn_faction(player_container, false)
	spawn_faction(enemy_container, true)

func clear_board() -> void:
	var placed_pieces: Array[Node] = get_tree().get_nodes_in_group("pieces")
	for piece_node in placed_pieces:
		if piece_node is Node:
			piece_node.queue_free()

func spawn_faction(container: FactionPieces, is_enemy: bool) -> void:
	# Determine faction color
	var color: Enums.FactionColor
	if is_enemy:
		color = enemy_faction
	else:
		color = player_faction

	# Determine the next row inward for the back-rank pieces
	var row0 : int
	var row1 : int
	var first_row: int = board.get_first_row()
	if is_enemy:
		row0 = first_row
		row1 = row0 + 1
	else:
		row0 = first_row + board.board_size - 1
		row1 = row0 - 1

	# ... now use `color`, `row0`, and `row1` below ...
	for file in pawn_row.size():
		spawn_one(pawn_row[file], color, container, file, row1)
		print(file)

	for file in back_row.size():
		spawn_one(back_row[file], color, container, file, row0)
		
func spawn_one(
	piece_type: Enums.PieceType,
	faction:   Enums.FactionColor,
	parent:    Node,
	file:      int,
	rank:      int
) -> void:
	# 1) Get the correct PackedScene from SkinManager
	var packed: PackedScene = SkinManager.get_piece(piece_type)
	if packed == null:
		push_error("No scene for %s %s" % [piece_type, faction])
		return

	# 2) Instance & add to the scene tree
	var piece : Node = packed.instantiate() as Piece
	parent.add_child(piece)

	## 3) Initialize piece data
	#piece.piece_stats.piece_type  = piece_type
	piece.piece_color = faction
#
	## 4) Register with the Board’s map
	#piece.board_pos = Vector2i(file, rank)
	#board.register_piece(piece)
#
	# Position piece in world
	piece.global_transform.origin = board.get_grid_position(file, rank)
	#print("Board pos:", file, rank, "→ world pos:", board.get_grid_position(file, rank))
	
	# Assign the appropriate visual texture via SkinManager & VisualsComponent
	var skin_id: SkinResource.SkinNames
	if faction == player_faction:
		skin_id = player_skin
	else:
		skin_id = enemy_skin
	var texture: Texture2D = SkinManager.get_texture(skin_id, faction, piece_type)
	if texture != null:
		piece.update_visuals(texture)
	else:
		push_warning("No texture found for %s using skin %s" %
			[piece_type, skin_id])
	
	

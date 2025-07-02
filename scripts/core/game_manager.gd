class_name GameManager

extends Node

@export_subgroup("Basic Nodes Setup")
@export var board : Board
@export var player_container : FactionPieces
@export var enemy_container : FactionPieces
@export var camera : Camera3D
@export var ui : Control

@export_subgroup("Skins & Factions")

@export var player_skin : SkinResource.SkinNames
@export var enemy_skin : SkinResource.SkinNames

@export var player_faction : Enums.FactionColor = Enums.FactionColor.WHITE
@export var enemy_faction : Enums.FactionColor = Enums.FactionColor.BLACK

@export_subgroup("Piece Layout: Player")

@export var player_pawn_rows: Array[Enums.PieceType] = [
	Enums.PieceType.PAWN, Enums.PieceType.PAWN, Enums.PieceType.PAWN, Enums.PieceType.PAWN,
	Enums.PieceType.PAWN, Enums.PieceType.PAWN, Enums.PieceType.PAWN, Enums.PieceType.PAWN,
]
@export var player_back_rows: Array[Enums.PieceType] = [
	Enums.PieceType.ROOK,   Enums.PieceType.KNIGHT, Enums.PieceType.BISHOP, Enums.PieceType.QUEEN,
	Enums.PieceType.KING,   Enums.PieceType.BISHOP, Enums.PieceType.KNIGHT, Enums.PieceType.ROOK,
]

@export_subgroup("Piece Layout: Enemy")

@export var enemy_pawn_rows: Array[Enums.PieceType] = [
	Enums.PieceType.PAWN, Enums.PieceType.PAWN, Enums.PieceType.PAWN, Enums.PieceType.PAWN,
	Enums.PieceType.PAWN, Enums.PieceType.PAWN, Enums.PieceType.PAWN, Enums.PieceType.PAWN,
]
@export var enemy_back_rows: Array[Enums.PieceType] = [
	Enums.PieceType.ROOK,   Enums.PieceType.KNIGHT, Enums.PieceType.BISHOP, Enums.PieceType.QUEEN,
	Enums.PieceType.KING,   Enums.PieceType.BISHOP, Enums.PieceType.KNIGHT, Enums.PieceType.ROOK,
]

var player_piece_count: int:
	get:
		return player_pawn_rows.size() + player_back_rows.size()
var enemy_piece_count: int:
	get:
		return enemy_pawn_rows.size() + enemy_back_rows.size()

func _ready() -> void:
	clear_board()
	spawn_faction(player_container, false)
	spawn_faction(enemy_container, true)
	
	# HACK: For testing the mouse handler signals
	EventBus.connect("tile_hovered", Callable(self, "on_tile_hover"))

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

	# Compute board rows based on actual GridMap coordinates
	var first_row: int = board.get_first_row()
	var row0: int
	if is_enemy:
		row0 = first_row
	else:
		row0 = first_row + board.board_size - 1

	var row1: int
	if is_enemy:
		row1 = row0 + 1
	else:
		row1 = row0 - 1

	# Select piece type arrays for this faction
	var pawn_types: Array[Enums.PieceType]
	var back_types: Array[Enums.PieceType]
	if is_enemy:
		pawn_types = enemy_pawn_rows
		back_types = enemy_back_rows
	else:
		pawn_types = player_pawn_rows
		back_types = player_back_rows

	# Spawn pawns, skipping any 'NONE' placeholders
	for file in pawn_types.size():
		var pt: Enums.PieceType = pawn_types[file]
		if pt == Enums.PieceType.NONE:
			continue
		spawn_one(pt, color, container, file, row1)

	# Spawn back‐rank pieces, skipping 'NONE' placeholders
	for file in back_types.size():
		var pt: Enums.PieceType = back_types[file]
		if pt == Enums.PieceType.NONE:
			continue
		spawn_one(pt, color, container, file, row0)
		
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
	
	
func on_tile_hover(tile : Vector2i) -> void:
	print("tile hovered", tile)

class_name PieceSpawner

extends Node

var board: Board
var players: Players
var piece_scn: PackedScene

func _ready() -> void:
	piece_scn = Refs.piece_base_scn

func setup(_board: Board, _players: Players) -> void:
	board = _board
	players = _players

func create_piece_instance(
	piece_res: PieceResource,
) -> Piece:
	
	var piece_inst: Piece = piece_scn.instantiate()
	if piece_inst == null:
		push_error("No piece base scene found for piece spawning")
		return
	piece_inst.set_config(piece_res)
	return piece_inst

func place_piece_instance(
	file:      int,
	rank:      int,
) -> void:
	pass
	
#func _spawn_all_players() -> void:
	#var root := get_node(players_container) as Node
	#for child in root.get_children():
		#if child is PlayerConfig:
			#var config : PlayerConfig = child
			#var container : FactionPieces = config.pieces
			#spawn_pieces(config, container)
#
#func spawn_pieces(config: PlayerConfig, container: FactionPieces) -> void:
	### Determine faction color
	#var color: Enums.FactionColor = config.faction
	#
	### Determine skin
	#var skin: SkinResource.SkinNames = config.skin # FIXME: I should move all enums to the Enums global class
	#
	## Compute board rows based on actual GridMap coordinates
	#var first_row: int = board.get_first_row()
	#var row1: int
	#var row2: int
	#
	## Determine rows based on Board Placement
	#var board_placement : Enums.BoardPlacement = config.board_placement
	#
	#match board_placement:
		#Enums.BoardPlacement.FRONT:
			#row1 = first_row + board.board_size - 1
			#row2 = row1 - 1
		#Enums.BoardPlacement.BACK:
			#row1 = first_row
			#row2 = row1 + 1
		#_:
			#pass
#
	### Select piece type arrays for this faction
	#var front_row: Array[Enums.PieceType] = config.front_row
	#var back_row: Array[Enums.PieceType] = config.back_row
	#
	### Spawn pawns, skipping any 'NONE' placeholders
	#for file in front_row.size():
		#var piece: Enums.PieceType = front_row[file]
		#if piece == Enums.PieceType.NONE:
			#continue
		#spawn_one(piece, skin, color, file, row2, container)
##
	### Spawn back‐rank pieces, skipping 'NONE' placeholders
	#for file in back_row.size():
		#var piece: Enums.PieceType = back_row[file]
		#if piece == Enums.PieceType.NONE:
			#continue
		#spawn_one(piece, skin, color, file, row1, container)
#
#func spawn_one(
	#piece_type: Enums.PieceType,
	#skin: SkinResource.SkinNames,
	#color:   Enums.FactionColor,
	#file:      int,
	#rank:      int,
	#container: FactionPieces
#) -> void:
	## 1) Get the correct PackedScene from SkinManager
	#var packed: PackedScene = SkinManager.get_piece(piece_type)
	#if packed == null:
		#push_error("No scene for %s %s" % [piece_type, color])
		#return
#
	## 2) Instance & add to the scene tree
	#var piece : Node = packed.instantiate() as Piece
	#container.add_child(piece)
#
	##3) Initialize piece data
	#piece.piece_color = color
##
	## Position piece in world
	#piece.global_transform.origin = board.get_grid_position(file, rank)
	#
	## Register piece in board's piece map
	#board.register_piece(piece, file, rank)
	#
	## Store board postition in the piece's data
	#piece.board_pos = Vector2i(file, rank)
	#
	## Store board for ref
	#piece.board = board
	#
	## TEST: Print Board info
	##print("Board pos:", file, rank, "→ world pos:", board.get_grid_position(file, rank))
	#
	## Assign the appropriate visual texture via SkinManager & VisualsComponent
	#var texture: Texture2D = SkinManager.get_texture(skin, color, piece_type)
	#if texture != null:
		#piece.update_visuals(texture)
	#else:
		#push_warning("No texture found for %s using skin %s" %
			#[piece_type, skin])
	#
	#

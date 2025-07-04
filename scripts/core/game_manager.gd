class_name GameManager

extends Node

@export_category("Basic Nodes Setup")
@export var board : Board
@export var players_container: NodePath
@export var camera : Camera3D
@export var ui : Control

func _ready() -> void:
	clear_board()
	_spawn_all_players()
	# Wire up player related FSM signals
	var players_node := get_node(players_container) as Node
	for child in players_node.get_children():
		if not (child is PlayerConfig):
			continue
		var cfg : PlayerConfig = child
		var player_id : Enums.Players = cfg.player_id
		var player_pieces : FactionPieces = cfg.pieces   # <- use your exported container
		match player_id:
			# NOTE: This is where the state machine is being hooked up, might need more control support later, expand here
			Enums.Players.PLAYER_1:
				for piece_node in player_pieces.get_children():
					if not (piece_node is Piece):
						continue
					var piece : Piece = piece_node as Piece
					piece.connect("piece_hovered", Callable(self, "on_piece_hover"))
					piece.connect("piece_hovered_exit", Callable(self, "on_piece_hover_out"))
					piece.connect("piece_selected", Callable(self, "on_piece_selection"))
					piece.connect("piece_selected_exit", Callable(self, "on_piece_selection_out"))
					var visuals : VisualsComponent = piece.visuals
					visuals.connect("condition_emitted", Callable(piece, "_on_condition"))
					var fsm : StateMachine = piece.state_machine
					fsm.connect("state_changed", Callable(piece, "_on_state_changed"))
			_:
				pass

func clear_board() -> void:
	var placed_pieces: Array[Node] = get_tree().get_nodes_in_group("pieces")
	for piece_node in placed_pieces:
		if piece_node is Node:
			piece_node.queue_free()

func _spawn_all_players() -> void:
	var root := get_node(players_container) as Node
	for child in root.get_children():
		if child is PlayerConfig:
			var config : PlayerConfig = child
			var container : FactionPieces = config.pieces
			spawn_pieces(config, container)

func spawn_pieces(config: PlayerConfig, container: FactionPieces) -> void:
	## Determine faction color
	var color: Enums.FactionColor = config.faction
	
	## Determine skin
	var skin: SkinResource.SkinNames = config.skin # FIXME: I should move all enums to the Enums global class
	
	# Compute board rows based on actual GridMap coordinates
	var first_row: int = board.get_first_row()
	var row1: int
	var row2: int
	
	# Determine rows based on Board Placement
	var board_placement : Enums.BoardPlacement = config.board_placement
	
	match board_placement:
		Enums.BoardPlacement.FRONT:
			row1 = first_row + board.board_size - 1
			row2 = row1 - 1
		Enums.BoardPlacement.BACK:
			row1 = first_row
			row2 = row1 + 1
		_:
			pass

	## Select piece type arrays for this faction
	var front_row: Array[Enums.PieceType] = config.front_row
	var back_row: Array[Enums.PieceType] = config.back_row
	
	## Spawn pawns, skipping any 'NONE' placeholders
	for file in front_row.size():
		var piece: Enums.PieceType = front_row[file]
		if piece == Enums.PieceType.NONE:
			continue
		spawn_one(piece, skin, color, file, row2, container)
#
	## Spawn back‐rank pieces, skipping 'NONE' placeholders
	for file in back_row.size():
		var piece: Enums.PieceType = back_row[file]
		if piece == Enums.PieceType.NONE:
			continue
		spawn_one(piece, skin, color, file, row1, container)

func spawn_one(
	piece_type: Enums.PieceType,
	skin: SkinResource.SkinNames,
	color:   Enums.FactionColor,
	file:      int,
	rank:      int,
	container: FactionPieces
) -> void:
	# 1) Get the correct PackedScene from SkinManager
	var packed: PackedScene = SkinManager.get_piece(piece_type)
	if packed == null:
		push_error("No scene for %s %s" % [piece_type, color])
		return

	# 2) Instance & add to the scene tree
	var piece : Node = packed.instantiate() as Piece
	container.add_child(piece)

	#3) Initialize piece data
	piece.piece_color = color
#
	# Position piece in world
	piece.global_transform.origin = board.get_grid_position(file, rank)
	
	# Register piece in board's piece map
	board.register_piece(piece, file, rank)
	
	# Store board postition in the piece's data
	piece.board_pos = Vector2i(file, rank)
	
	# Store board for ref
	piece.board = board
	
	# TEST: Print Board info
	#print("Board pos:", file, rank, "→ world pos:", board.get_grid_position(file, rank))
	
	# Assign the appropriate visual texture via SkinManager & VisualsComponent
	var texture: Texture2D = SkinManager.get_texture(skin, color, piece_type)
	if texture != null:
		piece.update_visuals(texture)
	else:
		push_warning("No texture found for %s using skin %s" %
			[piece_type, skin])
	
	
func on_tile_hover(tile : Vector2i) -> void:
	## TEST: Print Tile state
	## print("tile hovered", tile)
	pass

func on_piece_hover(piece: Piece, coord: Vector2i) -> void:
	var moves: Array[Vector2i] = piece.movement.get_all_moves(coord)
	var available_markers : Array[TileMarker] = board.get_available_markers(moves)
	board.change_markers_state(Enums.TileStates.HOVERED, available_markers)

func on_piece_hover_out(piece: Piece, coord: Vector2i) -> void:
	board.reset_markers()
	
func on_piece_selection(piece: Piece, coord: Vector2i) -> void:
	var moves: Array[Vector2i] = piece.movement.get_all_moves(coord)
	var available_markers : Array[TileMarker] = board.get_available_markers(moves)
	board.change_markers_state(Enums.TileStates.HOVERED, available_markers)

func on_piece_selection_out(piece: Piece, coord: Vector2i) -> void:
	board.reset_markers()

#func _on_piece_state_changed(piece: Piece, new_state: Enums.States) -> void:
	## always clear our old highlights first
	#board.clear_tile_states()
#
	#match new_state:
		#Enums.States.HIGHLIGHTED:
			## piece is under the cursor: show its legal moves
			#var moves: Array[Vector2i] = piece.movement_component.generate_moves(
				#piece.board_pos, piece.move_config, board.piece_map, board
			#)
			## highlight path (thin) and targets (bright)
			#board.show_legal_moves(moves)           # green
			#board.highlight_targets(moves)          # yellow
#
		#Enums.States.SELECTED:
			## piece was clicked: show everything more emphatically
			#var moves: Array[Vector2i] = piece.movement_component.generate_moves(
				#piece.board_pos, piece.move_config, board.piece_map, board
			#)
			#board.show_legal_moves(moves, true)     # pass `true` to use a stronger color
			#board.highlight_targets(moves, true)
#
		#_:
			## on any other state, we leave the board in its occupancy-only state
			#board.refresh_tile_states(piece.piece_color)

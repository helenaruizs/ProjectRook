class_name Board

extends Node3D

@export_range(1, 16, 1) var board_size: int = 8
@export var grid_map: GridMap
var tile_marker_scene: PackedScene
var piece_spawner: PieceSpawner
var players: Players
var teams: Dictionary[Enums.Alliance, Array] = {}

# Board Data
var tile_grid_positions: Dictionary[Vector2i, Vector3] = {}
var tile_markers: Dictionary[Vector2i, TileMarker] = {}
var piece_map: Dictionary[Vector2i, Piece] = {}

# State
var selected_piece: Piece = null
var active_markers: Dictionary[Enums.HighlightType, Array] = {}
var hover_markers: Dictionary[Enums.HighlightType, Array] = {}

func _ready() -> void:
	tile_marker_scene = Refs.tile_marker_scn
	SignalBus.piece_select.connect(self.on_piece_select)
	SignalBus.piece_deselect.connect(self.on_piece_deselect)
	SignalBus.piece_hover.connect(self.on_piece_hover)
	SignalBus.piece_hover_out.connect(self.on_piece_hover_out)

func setup(_players: Players, _piece_spawner: PieceSpawner) -> void:
	players = _players
	piece_spawner = _piece_spawner

# ----------- BOARD SETUP -----------
func scan_tiles() -> void:
	tile_grid_positions.clear()
	var used_cells: Array[Vector3i] = grid_map.get_used_cells()
	var tile_size: Vector3 = grid_map.cell_size
	var min_z: int = used_cells[0].z
	for cell: Vector3i in used_cells:
		min_z = min(min_z, cell.z)
		var flipped_y: int = board_size - 1 - (cell.z - min_z)
		var coord2d := Vector2i(cell.x, flipped_y)
		var local_pos: Vector3i = grid_map.map_to_local(cell)
		var world_pos: Vector3 = grid_map.to_global(local_pos)
		world_pos += Vector3(tile_size.x * 0.5, 0, -tile_size.z * 0.5)
		tile_grid_positions[coord2d] = world_pos

func spawn_markers() -> void:
	for marker : TileMarker in tile_markers.values():
		marker.queue_free()
	tile_markers.clear()
	for coord : Vector2i in tile_grid_positions.keys():
		var world_pos: Vector3 = tile_grid_positions[coord]
		var marker: TileMarker = tile_marker_scene.instantiate()
		add_child(marker)
		marker.global_transform.origin = world_pos + Vector3(0, 0.01, 0)
		marker.name = "Marker_%d_%d" % [coord.x, coord.y]
		marker.board = self
		tile_markers[coord] = marker
		marker.set_debug_label(str(coord), true)

func get_marker(coord: Vector2i) -> TileMarker:
	return tile_markers.get(coord, null)

# ----------- PIECE/PLAYER HELPERS -----------
func get_world_position(column: int, row: int) -> Vector3:
	var key := Vector2i(column, row)
	return tile_grid_positions.get(key, Vector3.ZERO)

func get_size() -> int:
	return board_size

func get_first_row() -> int:
	var min_row: int = 0
	for coord_key: Variant in tile_grid_positions.keys():
		var coord: Vector2i = coord_key as Vector2i
		if coord != null:
			min_row = min(min_row, coord.y)
	return min_row

func get_player_row_ranks(board_placement: Enums.BoardPlacement) -> Dictionary:
	var back_row_rank := 0
	var front_row_rank := 1
	if board_placement == Enums.BoardPlacement.BACK:
		back_row_rank = board_size - 1
		front_row_rank = board_size - 2
	elif board_placement == Enums.BoardPlacement.FRONT:
		back_row_rank = 0
		front_row_rank = 1
	return {
		"back": back_row_rank,
		"front": front_row_rank
	}

func register_teams(player_configs: Array[PlayerConfig]) -> void:
	teams.clear()
	for player in player_configs:
		if not teams.has(player.alliance):
			teams[player.alliance] = []
		teams[player.alliance].append(player)

# ----------- MOVEMENT HELPERS -----------
func has_tile(pos: Vector2i) -> bool:
	return tile_grid_positions.has(pos)

func has_marker(marker: TileMarker) -> bool:
	return active_markers.has(marker)

func has_piece_at(pos: Vector2i) -> bool:
	return piece_map.has(pos)

func get_piece_at(pos: Vector2i) -> Piece:
	return piece_map.get(pos, null)

func is_tile_occupied(pos: Vector2i) -> bool:
	return piece_map.has(pos)
#
#func get_markers_from_moves(moves: Dictionary) -> Dictionary:
	#var move_targets_pos: Array[Vector2i] = moves.get("move_targets", [])
	#var attack_targets_pos: Array[Vector2i] = moves.get("attack_targets", [])
	#var paths_pos: Array[Vector2i] = moves.get("paths", [])
	#
	#var move_target_markers: Array[TileMarker] = []
	#var attack_target_markers: Array[TileMarker] = []
	#var path_markers: Array[TileMarker] = []
#
	#for marker_pos: Vector2i in move_targets_pos:
		#var marker: TileMarker = get_marker(marker_pos)
		#if marker:
			#move_target_markers.append(marker)
#
	#for marker_pos: Vector2i in attack_targets_pos:
		#var marker: TileMarker = get_marker(marker_pos)
		#if marker:
			#attack_target_markers.append(marker)
#
	#for marker_pos: Vector2i in paths_pos:
		#var marker: TileMarker = get_marker(marker_pos)
		#if marker:
			#path_markers.append(marker)
	#
	#return {
		#"paths": path_markers,
		#"move_targets": move_target_markers,
		#"attack_targets": attack_target_markers
	#}

func get_piece_markers(moves: Dictionary, marker_type: Enums.HighlightType) -> Array[TileMarker]:
	var marker_pos: Array = moves.get(marker_type, [])
	var piece_markers: Array[TileMarker] = []
	for pos: Vector2i in marker_pos:
		var marker: TileMarker = get_marker(pos)
		if marker:
			piece_markers.append(marker)
			
	return piece_markers



# ----------- MARKER CONDITION/STATE MANAGEMENT -----------

func on_piece_hover(piece: Piece) -> void:
	if piece == selected_piece:
		return #TODO: behaviour for hovering a selected piece
	var piece_moves: Dictionary = piece.get_moves_cache()
	var path_markers: Array[TileMarker] = get_piece_markers(piece_moves, Enums.HighlightType.PATH)
	var move_markers: Array[TileMarker] = get_piece_markers(piece_moves, Enums.HighlightType.MOVE)
	var attack_markers: Array[TileMarker] = get_piece_markers(piece_moves, Enums.HighlightType.ATTACK)
	
	if selected_piece:
		path_markers = _filter_from_selected(path_markers, Enums.HighlightType.PATH)
		move_markers = _filter_from_selected(move_markers, Enums.HighlightType.MOVE)
		attack_markers = _filter_from_selected(attack_markers, Enums.HighlightType.ATTACK)
	
	hover_markers = {
		Enums.HighlightType.PATH: path_markers,
		Enums.HighlightType.MOVE: move_markers,
		Enums.HighlightType.ATTACK: attack_markers,
	}

	highlight_markers(path_markers, Enums.HighlightType.PATH)
	highlight_markers(move_markers, Enums.HighlightType.MOVE)
	highlight_markers(attack_markers, Enums.HighlightType.ATTACK)
	
func on_piece_hover_out(piece: Piece) -> void:
	if piece == selected_piece:
		return
	if hover_markers.size() != 0:
		clear_marker_highlights(hover_markers)
		hover_markers.clear()

func highlight_markers(markers: Array[TileMarker], highlight_type: Enums.HighlightType) -> void:
	for marker: TileMarker in markers:
		marker.apply_tile_highlight(highlight_type)

func clear_marker_highlights(hover_markers: Dictionary) -> void:
	var all_hover_markers: Array = Utils.flatten_dict_of_arrays(hover_markers)
	for marker: TileMarker in all_hover_markers:
		marker.apply_tile_highlight(Enums.HighlightType.NONE)

func on_piece_select(piece: Piece) -> void:
	if piece == selected_piece:
		on_piece_deselect(piece)
		return
	else:
		if selected_piece:
			on_piece_deselect(selected_piece)
		
		active_markers = hover_markers.duplicate()
		selected_piece = piece

		# Re-apply highlights for the new selection!
		for highlight_type: Enums.HighlightType in active_markers.keys():
			highlight_markers(active_markers[highlight_type], highlight_type)

func on_piece_deselect(piece: Piece) -> void:
	if piece == selected_piece:
		selected_piece = null
		clear_marker_highlights(active_markers)
		active_markers.clear()
		if piece.is_hovered():
			on_piece_hover(piece)
		return
	
	clear_marker_highlights(active_markers)

	active_markers.clear()
	selected_piece = null
	
#func on_piece_input(event_type: Enums.InteractionType, piece: Piece) -> void:
	#var moves: Dictionary = piece.get_moves()
	#var markers_dict: Dictionary = get_markers_from_moves(moves)
	#var paths: Array[TileMarker] = markers_dict.get("paths", [])
	#var move_targets: Array[TileMarker] = markers_dict.get("move_targets", [])
	#var attack_targets: Array[TileMarker] = markers_dict.get("attack_targets", [])
#
	#match event_type:
		#Enums.InteractionType.HOVER_IN:
			#unhighlight_hover_markers()
			#hover_markers.clear()
			#var non_active_paths: Array[TileMarker] = _filter_non_active(paths)
			#var non_active_moves: Array[TileMarker] = _filter_non_active(move_targets)
			#var non_active_attacks: Array[TileMarker] = _filter_non_active(attack_targets)
			#hover_markers += non_active_paths
			#hover_markers += non_active_moves
			#hover_markers += non_active_attacks
			#add_marker_conditions(non_active_paths, TileMarker.Conditions.PATH)
			#add_marker_conditions(non_active_moves, TileMarker.Conditions.TARGET)
			#add_marker_conditions(non_active_attacks, TileMarker.Conditions.ATTACK_TARGET)
		#
		#Enums.InteractionType.HOVER_OUT:
			#unhighlight_hover_markers()
			#hover_markers.clear()
		#
		#Enums.InteractionType.SELECT:
			#unhighlight_active_markers()
			#active_markers.clear()
			#active_markers += paths
			#active_markers += move_targets
			#active_markers += attack_targets
			#add_marker_conditions(paths, TileMarker.Conditions.PATH)
			#add_marker_conditions(move_targets, TileMarker.Conditions.TARGET)
			#add_marker_conditions(attack_targets, TileMarker.Conditions.ATTACK_TARGET)
			#selected_piece = piece
			#unhighlight_hover_markers()
			#hover_markers.clear()
		#
		#Enums.InteractionType.DESELECT:
			#print("DESELECTED")
			#unhighlight_active_markers()
			#active_markers.clear()
			#selected_piece = null
		#
		#_:
			#pass

func add_marker_conditions(markers: Array[TileMarker], condition: int) -> void:
	for marker: TileMarker in markers:
		if marker:
			marker.add_condition(condition)
			marker._check_state_and_apply()

func remove_marker_conditions(markers: Array[TileMarker], condition: int) -> void:
	for marker: TileMarker in markers:
		if marker:
			marker.remove_condition(condition)
			marker._check_state_and_apply()

#func unhighlight_hover_markers() -> void:
	#for marker: TileMarker in hover_markers:
		#if marker and not active_markers.has(marker):
			#marker.remove_condition(TileMarker.Conditions.PATH)
			#marker.remove_condition(TileMarker.Conditions.TARGET)
			#marker.remove_condition(TileMarker.Conditions.ATTACK_TARGET)
			#marker._check_state_and_apply()
#
#func unhighlight_active_markers() -> void:
	#for marker: TileMarker in active_markers:
		#if marker:
			#marker.remove_condition(TileMarker.Conditions.PATH)
			#marker.remove_condition(TileMarker.Conditions.TARGET)
			#marker.remove_condition(TileMarker.Conditions.ATTACK_TARGET)
			#marker._check_state_and_apply()

func _filter_from_selected(markers: Array[TileMarker], marker_type: Enums.HighlightType) -> Array[TileMarker]:
	var active_marker_array: Array = active_markers.get(marker_type, null)
	var result: Array[TileMarker] = []
	for m: TileMarker in markers:
		if m and not active_marker_array.has(m):
			result.append(m)
	return result

@tool
class_name Board

extends Node3D

@export_range(1, 16, 1) var board_size: int = 8
@export var grid_map: GridMap
var tile_marker_scene: PackedScene
var piece_spawner: PieceSpawner
var players: Players
var teams: Dictionary[Enums.Alliance, Array] = {} # alliance_id -> Array[PlayerConfig]

var active_piece: Piece = null

# Stores each cell’s grid‐coord → true world‐space origin
var tile_grid_positions: Dictionary[Vector2i, Vector3] = {}

# Stores cells -> tile markers
var tile_markers: Dictionary[Vector2i, TileMarker] = {}

# Stores which piece is in which tile, needs to be updated whenever pieces spawn or move
var piece_map: Dictionary[Vector2i, Piece] = {}

var active_markers: Array[TileMarker]

func _ready() -> void:
	tile_marker_scene = Refs.tile_marker_scn




func setup(_players: Players, _piece_spawner: PieceSpawner) -> void:
	players = _players
	piece_spawner = _piece_spawner


func scan_tiles() -> void:
	
	tile_grid_positions.clear()

	# get_used_cells() returns an Array of Vector3i for every occupied cell

	var used_cells: Array[Vector3i] = grid_map.get_used_cells()
	var tile_size: Vector3 = grid_map.cell_size # For later calculating the offset needed to place the pieces in the middle of the tile
	# Fix for the negative z value
	var min_z: int = used_cells[0].z

	# For each cell, map_to_local returns a Vector3 (local coords),
	# then to_global turns that into a world‐space Vector3
	for cell: Vector3i in used_cells:
		min_z = min(min_z, cell.z) # Fix for the negative z value (continued)
		var flipped_y: int = board_size - 1 - (cell.z - min_z)
		# drop the Y axis—chess is flat
		var coord2d := Vector2i(cell.x, flipped_y)
		# get world‐space pos
		var local_pos: Vector3i = grid_map.map_to_local(cell)
		var world_pos: Vector3 = grid_map.to_global(local_pos)
		
		# Center the piece on the tile by offsetting by half a tile in X and Z
		world_pos += Vector3(tile_size.x * 0.5, 0, -tile_size.z * 0.5) # HACK: This was a way to try and "pull" pieces to their correct z placement to compensate for the camera lens distortion

		# store under a Vector2i key
		tile_grid_positions[coord2d] = world_pos
		

func spawn_markers() -> void:
	# Clear any previous markers (if you ever re-run scan_tiles)
	for marker : TileMarker in tile_markers.values():
		marker.queue_free()
	tile_markers.clear()

	# For each (file,rank) → world_pos
	for coord : Vector2i in tile_grid_positions.keys():
		var world_pos: Vector3 = tile_grid_positions[coord]
		# instantiate the scene
		var marker: TileMarker = tile_marker_scene.instantiate()
		# parent it under the board (so it moves/rotates with you)
		add_child(marker)
		# nudge it up slightly so it renders over the tile
		marker.global_transform.origin = world_pos + Vector3(0, 0.01, 0)
		# name it (optional, but useful)
		marker.name = "Marker_%d_%d" % [coord.x, coord.y]
		# store it for later lookups
		tile_markers[coord] = marker
		
		# TEST: Debug label setup
		marker.set_debug_label(str(coord), true)

func get_marker(coord: Vector2i) -> TileMarker:
	return tile_markers.get(coord, null)

func get_world_position(column: int, row: int) -> Vector3:
	var key := Vector2i(column, row)
	return tile_grid_positions.get(key, Vector3.ZERO) # NOTE: Safe lookup, the method get() is used in case there is no key in the dict


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

#var hovered_piece_markers: Array[TileMarker] = []
#
#

#
#var opponent: PlayerConfig
#var enemy_color: Enums.FactionColor
#
#func _ready() -> void:
	#scan_tiles()
	#_spawn_markers()    # lay out all the TileMarkers
#
#

## 2) Spawns one TileMarker per board cell
#func _spawn_markers() -> void:
	## Clear any previous markers (if you ever re-run scan_tiles)
	#for marker : TileMarker in tile_markers.values():
		#marker.queue_free()
	#tile_markers.clear()
#
	## For each (file,rank) → world_pos
	#for coord : Vector2i in tile_grid_positions.keys():
		#var world_pos: Vector3 = tile_grid_positions[coord]
		## instantiate the scene
		#var marker: TileMarker = tile_marker_scene.instantiate()
		## parent it under the board (so it moves/rotates with you)
		#add_child(marker)
		## nudge it up slightly so it renders over the tile
		#marker.global_transform.origin = world_pos + Vector3(0, 0.01, 0)
		## name it (optional, but useful)
		#marker.name = "Marker_%d_%d" % [coord.x, coord.y]
		## store it for later lookups
		#tile_markers[coord] = marker
#
## NOTE: Helper function to map pieces to the board coords
#func register_piece(piece: Piece, column: int, row: int) -> void:
	#var coord := Vector2i(column, row)
	#piece_map[coord] = piece
	#
	#var marker: TileMarker = tile_markers[coord]
	##if there's a piece, it's oocupied
	#marker.add_condition(marker.Conditions.OCCUPIED)
	#marker.occupant = piece
	#
	## Friend vs enemy
	#if piece.piece_color == friendly_color:
		#marker.add_condition(marker.Conditions.HAS_FRIEND)
	#else:
		#marker.add_condition(marker.Conditions.HAS_ENEMY)
#
	## King
	#if piece.piece_type == Enums.PieceType.KING:
		#marker.add_condition(marker.Conditions.HAS_KING)
		#
	## Connect Marker signals to the pieces
	#marker.connect("marker_hovered", Callable(piece, "_on_piece_hover"))
	#marker.connect("marker_hovered_out", Callable(piece, "_on_piece_hover_out"))
	#marker.connect("marker_selected", Callable(piece, "_on_piece_selected"))
#
#func clear_tile_states() -> void:
	#for marker : TileMarker in tile_markers.values():
		#marker.set_state(Enums.TileStates.NORMAL)
		#
#
#
#func get_grid_position(column: int, row: int) -> Vector3:
	#var key := Vector2i(column, row)
	#return tile_grid_positions.get(key, Vector3.ZERO) # Safe lookup, the method get() is used in case there is no key in the dict
#
#
#func get_size() -> int:
	#return board_size
#
#
#func get_first_row() -> int:
	#var min_row: int = 0
	#for coord_key: Variant in tile_grid_positions.keys():
		#var coord: Vector2i = coord_key as Vector2i
		#if coord != null:
			#min_row = min(min_row, coord.y)
	#return min_row
#
#func get_existing_markers(positions: Array[Vector2i]) -> Array[TileMarker]:
	#var legal_markers: Array[TileMarker] = []
	#for pos in positions:
		## 1) is this square on our board?
		#if not tile_grid_positions.has(pos):
			#continue
		## 2) do we have a marker for it?
		#if tile_markers.has(pos):
			#legal_markers.append(tile_markers[pos])
		## (if you created markers for every tile in scan_tiles(),
		##  you could skip the has() check and just append)
	#return legal_markers
#
#func get_markers_from_moves(moves: Dictionary[int, Array]) -> Array[TileMarker]:
	#var markers: Array[TileMarker] = []
	#for coord_array: Array in moves.values():
		#for coord : Vector2i in coord_array:
			## Make sure we actually have a marker for that tile
			#if tile_markers.has(coord):
				## Using `get()` avoids a second lookup if you want
				#var marker: TileMarker = tile_markers.get(coord)
				#markers.append(marker)
	#return markers
#
#func change_markers_state(moves: Dictionary[Enums.TileStates, Array], selected: bool = false) -> void:
	## 'moves' maps a TileState -> Array of board coords
	#for tile_state: Enums.TileStates in moves.keys():
		#var positions: Array = moves[tile_state]
		#for pos: Vector2i in positions:
			#if tile_markers.has(pos):
				#var marker: TileMarker = tile_markers[pos]
				#marker.set_state(tile_state)
	#
## Call this when a piece becomes selected
#func set_active_piece(piece: Piece, moves: Dictionary[int, Array]) -> void:
	#active_piece = piece
	#active_markers = moves.values().duplicate()
	##change_markers_state(active_markers)
#
## Call this when a piece is deselected
#func clear_active_piece() -> void:
	#active_piece = null
	#active_markers.clear()
	##reset_markers(true)  # force a full clear
#
#func set_hovered_piece_markers(target_markers: Array[TileMarker], path_markers: Array[TileMarker]) -> void:
	#hovered_piece_markers = target_markers.duplicate() + path_markers.duplicate()
#
#func clear_hovered_piece_markers() -> void:
	#hovered_piece_markers.clear()
#
#func reset_markers(markers: Array[TileMarker]) -> void:
	#for marker : TileMarker in markers:
		#marker.set_state(Enums.TileStates.NORMAL)
#
#func update_marker_conditions(markers: Array[TileMarker], conditions : int, add: bool = true) -> void:
	#for marker: TileMarker in markers:
		#if add:
			#marker.add_condition(conditions)
		#else:
			#marker.remove_condition(conditions)
#
#func register_players(_player_one: PlayerConfig, _opponent: PlayerConfig) -> void:
	#player_one = _player_one
	#friendly_color = player_one.faction
	#opponent = _opponent
	#enemy_color = opponent.faction

@tool
class_name Board

extends Node3D

# Standard chess is 8×8
@export_range(1, 16, 1) var board_size: int = 8
@export var tile_marker_scene: PackedScene

@onready var grid_map: GridMap = $GridMap

# Stores each cell’s grid‐coord → true world‐space origin
var tile_grid_positions: Dictionary[Vector2i, Vector3] = {}

# Stores cells -> tile markers
var tile_markers: Dictionary[Vector2i, TileMarker] = {}

# Stores which piece is in which tile, needs to be updated whenever pieces spawn or move
var piece_map: Dictionary[Vector2i, Piece] = {}

func _ready() -> void:
	scan_tiles()
	_spawn_markers()    # lay out all the TileMarkers


func scan_tiles() -> void:
	tile_grid_positions.clear()

	# get_used_cells() returns an Array of Vector3i for every occupied cell

	var used_cells: Array[Vector3i] = grid_map.get_used_cells()
	var tile_size: Vector3 = grid_map.cell_size # For later calculating the offset needed to place the pieces in the middle of the tile

	# For each cell, map_to_local returns a Vector3 (local coords),
	# then to_global turns that into a world‐space Vector3
	for cell: Vector3i in used_cells:
		# drop the Y axis—chess is flat
		var coord2d := Vector2i(cell.x, cell.z)
		# get world‐space pos
		var local_pos: Vector3i = grid_map.map_to_local(cell)
		var world_pos: Vector3 = grid_map.to_global(local_pos)
		
		# Center the piece on the tile by offsetting by half a tile in X and Z
		world_pos += Vector3(tile_size.x * 0.5, 0, -tile_size.z * 0.45 - (world_pos.z * 0.01)) # HACK: This was a way to try and "pull" pieces to their correct z placement to compensate for the camera lens distortion

		# store under a Vector2i key
		tile_grid_positions[coord2d] = world_pos
		

# 2) Spawns one TileMarker per board cell
func _spawn_markers() -> void:
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
		marker.global_transform.origin = world_pos + Vector3(0, 0.1, 0)
		# name it (optional, but useful)
		marker.name = "Marker_%d_%d" % [coord.x, coord.y]
		# store it for later lookups
		tile_markers[coord] = marker

# NOTE: Helper function to map pieces to the board coords
func register_piece(piece: Piece, column: int, row: int) -> void:
	var coord := Vector2i(column, row)
	piece_map[coord] = piece
	
func clear_tile_states() -> void:
	for marker : TileMarker in tile_markers.values():
		marker.set_state(Enums.TileStates.NORMAL)
		
func refresh_tile_states(player_faction: Enums.FactionColor) -> void:
	for coord : Vector2i in tile_markers.keys():
		var marker : TileMarker = tile_markers[coord]
		var occupant : Piece = piece_map.get(coord, null)

		if occupant == null:
			# no piece here
			marker.set_state(Enums.TileStates.NORMAL)
		else:
			# we have a piece—decide friend vs enemy
			if occupant.piece_color == player_faction:
				marker.set_state(Enums.TileStates.OCCUPIED_PLAYER)
			else:
				marker.set_state(Enums.TileStates.OCCUPIED_OPPONENT)


func get_grid_position(column: int, row: int) -> Vector3:
	var key := Vector2i(column, row)
	return tile_grid_positions.get(key, Vector3.ZERO) # Safe lookup, the method get() is used in case there is no key in the dict


func get_size() -> int:
	return board_size


func get_first_row() -> int:
	var min_row: int = 0
	for coord_key: Variant in tile_grid_positions.keys():
		var coord: Vector2i = coord_key as Vector2i
		if coord != null:
			min_row = min(min_row, coord.y)
	return min_row


## show_legal_moves(moves, selected=false)
#func show_legal_moves(moves: Array[Vector2i], selected: bool = false) -> void:
	#for coord in moves:
		#if not tile_markers.has(coord):
			#continue
		#var occ = piece_map.get(coord, null)
		#if occ == null:
			#var state = selected
				#? Enums.TileStates.LEGAL_MOVE_HIGHLIGHTED
				#: Enums.TileStates.LEGAL_MOVE
			#tile_markers[coord].set_state(state)
		#else:
			## capture spots always use OCCUPIED_ENEMY
			#tile_markers[coord].set_state(Enums.TileStates.OCCUPIED_OPPONENT)
#
## highlight_targets(moves, selected=false)
#func highlight_targets(moves: Array[Vector2i], selected: bool = false) -> void:
	#for coord in moves:
		## only where a move actually ends
		#if not tile_markers.has(coord):
			#continue
		#var state = selected
			#? Enums.TileState.LEGAL_MOVE_HOVERED  # or a new SELECTED_TARGET state
			#: Enums.TileState.LEGAL_MOVE_HOVERED
		#tile_markers[coord].set_state(state)

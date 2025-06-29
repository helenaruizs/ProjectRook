@tool
class_name Board

extends Node3D


@onready var grid_map: GridMap = $GridMap

# Stores each cell’s grid‐coord → true world‐space origin
var tile_grid_positions: Dictionary[Vector2i, Vector3] = {}

# Standard chess is 8×8
@export_range(1, 16, 1) var board_size: int = 8

func _ready() -> void:
	scan_tiles()
	var test1 : Vector3 = get_grid_position(1,-1)
	var test2 : Vector3 = get_grid_position(3,-5)
	var test3 : Vector3 = get_grid_position(1,0)
	var test4 : Vector3 = get_grid_position(6,0)
	var test5 : Vector3 = get_grid_position(6,-1)
	print(test1, test2, test3, test4, test5)


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
		

	print("Cached %d tiles" % tile_grid_positions.size())
	print(tile_grid_positions)


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

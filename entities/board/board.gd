@tool
class_name Board

extends Node3D


# Make sure your scene has a child GridMap node named “GridMap”
@onready var grid_map: GridMap = $GridMap

# Stores each cell’s grid‐coord → true world‐space origin
var tile_grid_positions: Dictionary[Vector2i, Vector3i] = {}

# Standard chess is 8×8
@export_range(1, 16, 1) var board_size: int = 8

func _ready() -> void:
	scan_tiles()


func scan_tiles() -> void:
	tile_grid_positions.clear()

	# 1) get_used_cells() returns an Array of Vector3i for every occupied cell
	# 
	var used_cells: Array[Vector3i] = grid_map.get_used_cells()

	# 2) For each cell, map_to_local returns a Vector3 (local coords),
	#    then to_global turns that into a world‐space Vector3
	for cell: Vector3i in used_cells:
		# 1) drop the Y axis—chess is flat
		var coord2d := Vector2i(cell.x, cell.z)
		# 2) get world‐space pos
		var local_pos: Vector3i = grid_map.map_to_local(cell)
		var world_pos: Vector3i = grid_map.to_global(local_pos)
		# 3) store under a Vector2i key
		tile_grid_positions[coord2d] = world_pos
		

	print("Cached %d tiles" % tile_grid_positions.size())
	print(tile_grid_positions)


func get_grid_position(column: int, row: int) -> Vector3i:
	var key : Vector2i = Vector2i(column, row)
	return tile_grid_positions.get(key, Vector3i.ZERO) # Safe lookup, the method get() is used in case there is no key in the dict


func get_size() -> int:
	return board_size
	

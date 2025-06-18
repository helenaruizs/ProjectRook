@tool
class_name BoardGrid
extends Node3D

# Make sure your scene has a child GridMap node named “GridMap”
@onready var grid_map: GridMap = $GridMap

# Stores each cell’s grid‐coord → true world‐space origin
var tile_positions: Dictionary[Vector3i, Vector3] = {}


func _ready() -> void:
	scan_tiles()


func scan_tiles() -> void:
	tile_positions.clear()

	# 1) get_used_cells() returns an Array of Vector3i for every occupied cell
	# 
	var used_cells: Array[Vector3i] = grid_map.get_used_cells()

	# 2) For each cell, map_to_local returns a Vector3 (local coords),
	#    then to_global turns that into a world‐space Vector3
	for cell: Vector3i in used_cells:
		var local_pos: Vector3 = grid_map.map_to_local(cell)    # local offset of this tile
		var world_pos: Vector3 = grid_map.to_global(local_pos)  # convert to true world‐space
		tile_positions[cell] = world_pos

	print("Cached %d tiles" % tile_positions.size())

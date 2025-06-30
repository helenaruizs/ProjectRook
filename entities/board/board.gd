@tool
class_name Board

extends Node3D

#@onready var sprite: Sprite3D = $Sprite3D
#@onready var hover_area: Area3D = $Area3D
#
#
#func _ready() -> void:
	#hover_area.input_ray_pickable = true
	#hover_area.mouse_entered.connect(_on_mouse_entered)
	##hover_area.input_event.connect(_on_input_event)
	#
	#
#func set_texture(tex: Texture2D) -> void:
	#sprite.texture = tex
#
#
#func _on_mouse_entered() -> void:
	## Tell the game which piece is hovered. We assume the parent is the Piece node.
	#var piece := get_parent() as Piece
	#EventBus.emit_signal("piece_hovered", piece, piece.board_pos)
#

@onready var grid_map: GridMap = $GridMap

# Stores each cell’s grid‐coord → true world‐space origin
var tile_grid_positions: Dictionary[Vector2i, Vector3] = {}

# Standard chess is 8×8
@export_range(1, 16, 1) var board_size: int = 8

func _ready() -> void:
	scan_tiles()


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

class_name Board

extends Node3D

var tile_map_IDs : Dictionary[String, Vector3] = {}

var board_grid : Dictionary[Vector2i, Vector3] = {}

func _ready():
	for tile in get_children():
		if tile is BoardTile:
			# PConverting to nice string IDs like A1
			var file_str = BoardTile.Files.keys()[tile.file]
			var rank_str = BoardTile.Ranks.keys()[tile.rank].trim_prefix("_")
			var id_str   = file_str + rank_str
			
			# Populating dictionaries
			var pos : Vector3 = tile.global_position
			tile_map_IDs[id_str] = pos
			board_grid[Vector2i(tile.file, tile.rank)] = pos
			
			# Connecting to the mouse signals from the tiles
			tile.tile_hovered.connect(Callable(self, "on_tile_hover"))
	print(board_grid)


# Methods for the board to pass up information about the tiles

func get_tile_by_id(tile_id: String) -> BoardTile:
	return tile_map_IDs.get(tile_id)

func get_position_by_id(tile_id: String) -> Vector3:
	var tile = tile_map_IDs.get(tile_id)
	if tile:
		return tile
	else:
		push_error("Not able to retrieve tile position")
		return Vector3.ZERO  # Safe fallback

#func get_id_by_tile(tile: BoardTile) -> String:
	#for id in tile_map_IDs:
		#if tile_map_IDs[id] == tile:
			#return id
	#return ""
	
func on_tile_hover(file_enum: int, rank_enum: int) -> void:
	# recreate your keys
	var file_str = BoardTile.Files.keys()[ file_enum ]
	var rank_str = BoardTile.Ranks.keys()[ rank_enum ].trim_prefix("_")
	var id_str   = file_str + rank_str
	var coord    = Vector2i(file_enum, rank_enum)

	## example 1: lookup world-pos by string
	#if tile_map_IDs.has(id_str):
		#print("Hovered “", id_str, "” at ", tile_map_IDs[id_str])
	#else:
		#push_error("no entry in tile_map_IDs for “%s”" % id_str)
#
	## example 2: lookup world-pos by Vector2i
	#if board_grid.has(coord):
		#print("  or by coord", coord, "→", board_grid[coord])
	#else:
		#push_error("no entry in board_grid for %s" % coord)

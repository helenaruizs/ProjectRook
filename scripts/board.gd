class_name Board

extends Node3D

#var files_in_numbers : Dictionary = {
	#"A" = 1,
	#"B" = 2,
	#"C" = 3,
	#"D" = 4,
	#"E" = 5,
	#"F" = 6,
	#"G" = 7,
	#"H" = 8,
#}

var tile_map_IDs : Dictionary = {}

var board_grid : Dictionary = {}

func _ready():
	for tile in get_children():
		if tile is BoardTile:
			# Populating the ID dictionary
			var file_str = BoardTile.Files.keys()[tile.file]  # Convert enum to string like "A"
			var rank_str = BoardTile.Ranks.keys()[tile.rank]  # Convert enum to string like "_1"
			var key = file_str + rank_str.trim_prefix("_")    # Get "A1", "B2", etc.
			tile_map_IDs[key] = tile.global_transform.origin
			
			## Populating the 2d grid dictionary
			var row = tile.file  # Convert enum to string like "A"
			var column = tile.rank  # Convert enum to string like "_1"
			var label = [row, column]   # Get "A1", "B2", etc.
			board_grid[label] = tile.global_transform.origin
			
			# Connecting to the mouse signals from the tiles
			tile.tile_hovered.connect(self.on_tile_hover)
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

func get_id_by_tile(tile: BoardTile) -> String:
	for id in tile_map_IDs:
		if tile_map_IDs[id] == tile:
			return id
	return ""
	
func on_tile_hover():
	print("Tile hovered!")

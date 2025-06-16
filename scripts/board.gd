class_name Board

extends Node3D

var tile_map: Dictionary = {}

func _ready():
	for tile in get_children():
		if tile is BoardTile:
			var file_str = BoardTile.Files.keys()[tile.file]  # Convert enum to string like "A"
			var rank_str = BoardTile.Ranks.keys()[tile.rank]  # Convert enum to string like "_1"
			var key = file_str + rank_str.trim_prefix("_")    # Get "A1", "B2", etc.
			tile_map[key] = tile.global_transform.origin
	#print(tile_map)


# Methods for the board to pass up information about the tiles

func get_tile_by_id(tile_id: String) -> BoardTile:
	return tile_map.get(tile_id)

func get_position_by_id(tile_id: String) -> Vector3:
	var tile = tile_map.get(tile_id)
	if tile:
		return tile
	else:
		push_error("Not able to retrieve tile position")
		return Vector3.ZERO  # Safe fallback

func get_id_by_tile(tile: BoardTile) -> String:
	for id in tile_map:
		if tile_map[id] == tile:
			return id
	return ""

extends Node

# Piece signals
signal piece_selected(piece: Piece, coord: Vector2i)
signal piece_move(piece: Piece, from_coord: Vector2i, to_coord: Vector2i)

# Board signals
signal tile_hovered(coord: Vector2i)

extends Node

# TODO: Signal/Event Bus is total placeholder atm

# Piece signals
signal piece_hovered(piece: Piece, coord: Vector2i) 
signal piece_hover_end(piece: Piece, coord: Vector2i) 
signal piece_move(piece: Piece, from_coord: Vector2i, to_coord: Vector2i) # TODO: This theoretically will be the signal the click of the mouse on a valid board tile will send to the currently selected piece to move

# Board signals
signal tile_hovered(coord: Vector2i) # TODO: This will be used for the tile hover detection on the board tiles
signal tile_clicked(coord: Vector2i)

# Tile Marker signals

signal marker_hovered(tile_marker: TileMarker, piece: Piece )
signal marker_hovered_out(tile_marker: TileMarker, piece: Piece)
signal marker_selected()

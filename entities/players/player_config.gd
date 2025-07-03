class_name PlayerConfig

extends Node

@export var player_id : Enums.Players

@export_category("Pieces Container")
@export var pieces : FactionPieces

@export_category("Skins & Factions")

@export var skin : SkinResource.SkinNames

@export var faction : Enums.FactionColor = Enums.FactionColor.WHITE

@export_category("Piece Layout")

@export var board_placement : Enums.BoardPlacement

@export var front_row: Array[Enums.PieceType] = [
	Enums.PieceType.PAWN, Enums.PieceType.PAWN, Enums.PieceType.PAWN, Enums.PieceType.PAWN,
	Enums.PieceType.PAWN, Enums.PieceType.PAWN, Enums.PieceType.PAWN, Enums.PieceType.PAWN,
]
@export var back_row: Array[Enums.PieceType] = [
	Enums.PieceType.ROOK,   Enums.PieceType.KNIGHT, Enums.PieceType.BISHOP, Enums.PieceType.QUEEN,
	Enums.PieceType.KING,   Enums.PieceType.BISHOP, Enums.PieceType.KNIGHT, Enums.PieceType.ROOK,
]

var piece_count: int:
	get:
		return front_row.size() + back_row.size()

var selected_piece : Piece = null

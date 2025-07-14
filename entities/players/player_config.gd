class_name PlayerConfig

extends Resource

@export var player_type : Enums.PlayerType

@export var alliance: Enums.Alliance

@export_category("Skins & Factions")

@export var skin : SkinResource.SkinNames

@export var faction : Enums.FactionColor

@export_category("Piece Layout")

@export var board_placement : Enums.BoardPlacement

@export var front_row: Array[PieceResource] = [
	Refs.PAWN, Refs.PAWN, Refs.PAWN, Refs.PAWN,
	Refs.PAWN, Refs.PAWN, Refs.PAWN, Refs.PAWN,
]
@export var back_row: Array[PieceResource] = [
	Refs.ROOK, Refs.KNIGHT, Refs.BISHOP, Refs.QUEEN,
	Refs.KING, Refs.BISHOP, Refs.KNIGHT, Refs.ROOK,
]

var piece_count: int:
	get:
		return front_row.size() + back_row.size()

var selected_piece : Piece = null

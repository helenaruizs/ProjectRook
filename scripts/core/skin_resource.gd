class_name SkinResource

extends Resource

enum SkinNames {
	CLASSIC,
	RETRO,
	FANTASY,
}

@export var id : SkinNames
@export var faction_color : Enums.FactionColor

@export_subgroup("Pieces")
@export var bishop : Texture2D
@export var king : Texture2D
@export var knight : Texture2D
@export var pawn : Texture2D
@export var queen : Texture2D
@export var rook : Texture2D


# Helper "getter"
func get_texture_for(piece_type: Enums.PieceType) -> Texture2D:
	match piece_type:
		Enums.PieceType.PAWN:   return pawn
		Enums.PieceType.ROOK:   return rook
		Enums.PieceType.KNIGHT: return knight
		Enums.PieceType.BISHOP: return bishop
		Enums.PieceType.QUEEN:  return queen
		Enums.PieceType.KING:   return king
	return null

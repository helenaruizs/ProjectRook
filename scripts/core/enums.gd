class_name Enums

extends Object

enum PieceType {
	PAWN,
	KNIGHT,
	BISHOP,
	ROOK,
	QUEEN,
	KING,
	}

enum PieceColor {
	WHITE,
	BLACK,
	}

enum MoveStyle {
	SLIDE,
	JUMP,
}

enum MovePattern {
	STRAIGHT,
	DIAGONAL,
	L_SHAPE,
}

enum MoveLenght {
	LONG,
	SHORT,
}

enum Files {
	A,
	B,
	C,
	D,
	E,
	F,
	G,
	H,
}

enum Ranks {
	_1,
	_2,
	_3,
	_4,
	_5,
	_6,
	_7,
	_8,
}

# 2D directions for grid scans
const DIRS := {
	"up": Vector2i( 0, -1),
	"down": Vector2i( 0, 1),
	"left": Vector2i( -1, 0),
	"right": Vector2i( 1, 0),
	"up-left": Vector2i( -1, -1),
	"up-right": Vector2i( 1, -1),
	"down-left": Vector2i( -1, 1),
	"down-right": Vector2i( 1, 1),
}

enum GameTurn {
	PLAYER,
	ENEMY,
}

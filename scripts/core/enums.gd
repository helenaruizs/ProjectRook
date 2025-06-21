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

enum FactionColor {
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

enum MoveLength {
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

enum GameTurn {
	PLAYER,
	ENEMY,
}

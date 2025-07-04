class_name Enums

extends Object

enum Conditions {
	HOVER_ENTER,
	HOVER_EXIT,
	CLICK,
}

enum States {
	IDLE,
	HIGHLIGHTED,
	SELECTED,
	MOVING,
}

enum TileStates {
	NORMAL,
	LEGAL_MOVE,
	LEGAL_MOVE_HOVERED,
	SELECTED,
	MOVE_PATH,
	HOVERED,
	OCCUPIED_PLAYER,  # tile has one of your own pieces
	OCCUPIED_OPPONENT,    # tile has an enemy piece (a capture target)
	TARGET,
}

enum PieceType {
	NONE,
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
	ALL_DIRS,
	SINGLE_DIR,
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

enum Players {
	PLAYER_1,
	PLAYER_2
}

enum GameTurn {
	PLAYER,
	ENEMY,
}

enum BoardPlacement {
	FRONT,
	BACK,
}

static func enum_to_string(enum_dict: Dictionary, value: int) -> String:
	for key : String in enum_dict.keys():
		if enum_dict[key] == value:
			return key
	# fallback
	return str(value)

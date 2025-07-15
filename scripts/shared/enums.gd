class_name Enums

extends Object

enum Conditions {
	HOVER_ENTER,
	HOVER_EXIT,
	SELECTED,
}

enum InteractionType {
	SELECT,
	HOVER_IN,
	HOVER_OUT,
	DRAG,
	RELEASE,
	SECONDARY_ACTION, # right-click
	DESELECT,
}

enum HighlightType {
	NONE,
	MOVE,
	ATTACK,
	SELECTED,
	PATH,
	CHECK,
	ENEMY,
	FRIEND,
}

enum States {
	IDLE,
	HIGHLIGHTED,
	SELECTED,
	MOVING,
}

enum TileStates {
	NORMAL,
	AVAILABLE,
	BLOCKED,
	HAS_ACTIVE_PIECE,
	MOVE_PATH,
	MOVE_TARGET,
	HAS_ENEMY,
	HAS_FRIEND,
	OBJECTIVE,
	HAS_ENEMY_KING,
	HAS_PLAYER_KING,
	ATTACK_TARGET,
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

enum PlayerType {
	HUMAN,
	NPC,
	REMOTE,
}

enum Alliance {
	FRIEND,
	FOE,
	NEUTRAL,
}

enum GameTurn {
	PLAYER,
	ENEMY,
}

enum BoardPlacement {
	FRONT,
	BACK,
}

enum Levels {
	NONE,
	LEVEL_0,
	LEVEL_1,
	LEVEL_2,
}

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT,
	UP_LEFT,
	UP_RIGHT,
	DOWN_LEFT,
	DOWN_RIGHT
}

static func enum_to_string(enum_dict: Dictionary, value: int) -> String:
	for key : String in enum_dict.keys():
		if enum_dict[key] == value:
			return key
	# fallback
	return str(value)

static func dir_to_vector(dir: Direction) -> Vector2i:
	match dir:
		Direction.UP: return Vector2i(0, 1)
		Direction.DOWN: return Vector2i(0, -1)
		Direction.LEFT: return Vector2i(-1, 0)
		Direction.RIGHT: return Vector2i(1, 0)
		Direction.UP_LEFT: return Vector2i(-1, 1)
		Direction.UP_RIGHT: return Vector2i(1, 1)
		Direction.DOWN_LEFT: return Vector2i(-1, -1)
		Direction.DOWN_RIGHT: return Vector2i(1, -1)
		_: return Vector2i(0, 0)

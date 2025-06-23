class_name MovementComponent

extends Node

# Store the knight's offsets instead of recalculating every time
static var KNIGHT_OFFSETS: Array[Vector2i] = compute_knight_offsets()

var piece : Piece

func _ready() -> void:
	piece = get_parent() as Piece

# Given a pattern, return the base directions or offsets
func get_directions(move_pattern : Enums.MovePattern) -> Array[Vector2i]:
	match move_pattern:
		Enums.MovePattern.STRAIGHT:
			return [
				Const.DIRS["up"],
				Const.DIRS["down"],
				Const.DIRS["left"],
				Const.DIRS["right"],
			]
		Enums.MovePattern.DIAGONAL:
			return [
				Const.DIRS["up_left"],
				Const.DIRS["up_right"],
				Const.DIRS["down_left"],
				Const.DIRS["down_right"],
			]
		Enums.MovePattern.ALL_DIRS:
			return [
				Const.DIRS["up"],
				Const.DIRS["down"],
				Const.DIRS["left"],
				Const.DIRS["right"],
				Const.DIRS["up_left"],
				Const.DIRS["up_right"],
				Const.DIRS["down_left"],
				Const.DIRS["down_right"],
			]
		Enums.MovePattern.L_SHAPE:
			# knights—hard-coded offsets
			return KNIGHT_OFFSETS
		_:
			return []


# private helper
static func compute_knight_offsets() -> Array[Vector2i]:
	
	var offsets: Array[Vector2i] = []
	
	# Define the two base steps for a knight’s “L”
	var bases: Array[Vector2i] = [
		Vector2i(1, 2),
		Vector2i(2, 1),
	]
	
	# Sign multipliers
	var signs: Array[int] = [-1, 1]
	
	for base : Vector2i in bases:
		for sx :int in signs:
			for sy : int in signs:
				offsets.append(Vector2i(base.x * sx, base.y * sy))
	
	return offsets



func scan_legal_tiles() -> Array:
	var tiles := []
	return tiles


func move_to_position(world_pos: Vector3) -> void:
	# Move the parent Piece to the target position in world space
	get_parent().global_transform.origin = world_pos

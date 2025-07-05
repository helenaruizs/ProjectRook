class_name MovementComponent

extends Node

# Cache knight offsets once
static var KNIGHT_OFFSETS: Array[Vector2i] = compute_knight_offsets()

# Quick access to the piece and the board
@onready var piece := get_parent()
@onready var board : Board = piece.board

#— Helpers —#

static func compute_knight_offsets() -> Array[Vector2i]:
	var offsets: Array[Vector2i] = []  # type: Array[Vector2i]
	var bases:= [Vector2i(1,2), Vector2i(2,1)]
	var signs:= [-1, 1]
	for base: Vector2i in bases:
		for sx: int in signs:
			for sy: int in signs:
				offsets.append(Vector2i(base.x * sx, base.y * sy))
	return offsets

func get_directions(pattern: Enums.MovePattern) -> Array[Vector2i]:
	match pattern:
		Enums.MovePattern.STRAIGHT:
			return [
				Const.DIRS.up,
				Const.DIRS.down,
				Const.DIRS.left,
				Const.DIRS.right,
			]
		Enums.MovePattern.DIAGONAL:
			return [
				Const.DIRS.up_left,
				Const.DIRS.up_right,
				Const.DIRS.down_left,
				Const.DIRS.down_right,
			]
		Enums.MovePattern.ALL_DIRS:
			return [
				Const.DIRS.up, Const.DIRS.down,
				Const.DIRS.left, Const.DIRS.right,
				Const.DIRS.up_left, Const.DIRS.up_right,
				Const.DIRS.down_left, Const.DIRS.down_right,
			]
		Enums.MovePattern.L_SHAPE:
			return KNIGHT_OFFSETS
		Enums.MovePattern.SINGLE_DIR:
			return [
				Const.DIRS.up,
			]
		_:
			return []

func _pawn_double_step_allowed(origin: Vector2i) -> bool:
	if piece.piece_type != Enums.PieceType.PAWN:
		return false
	if piece.has_moved:
		return false
	return true

#— Public API —#
func get_all_moves(origin: Vector2i) -> Dictionary:
	var paths: Array[Vector2i] = []
	var targets: Array[Vector2i] = []

	var piece_is_selected : bool = piece.is_selected

	# 1) Knights (L-shape) are a special case
	if piece.move_pattern == Enums.MovePattern.L_SHAPE:
		for offset in KNIGHT_OFFSETS:
			var pos: Vector2i = origin + offset
			if not piece.board.tile_grid_positions.has(pos): # Stop within boundaries of the board
				continue
			if piece.board.piece_map.has(pos):
				targets.append(pos)
			else:
				targets.append(pos)
		return { "paths": paths, "targets": targets }


	# 2) Everybody else uses directions
	var dirs := get_directions(piece.move_pattern)
	
#region Step Calculation
	var is_long : bool
	if piece.move_length == Enums.MoveLength.LONG:
		is_long = true
	else:
		is_long = false
	var max_steps : int
	if is_long:
		max_steps = piece.board.board_size
	else:
		max_steps = 1
	if not is_long and _pawn_double_step_allowed(origin):
		max_steps = 2
#endregion
	
	for d in dirs:
		var dir_positions: Array[Vector2i] = []
		for step in range(1, max_steps + (0 if is_long else 1)):
			var pos := origin + d * step
			if not piece.board.tile_grid_positions.has(pos): # Stop within boundaries of the board
				break
				
			if piece.board.piece_map.has(pos):
				targets.append(pos)
			else:
				dir_positions.append(pos)
		# once done with this dir, move all but last into paths, last into targets
		if dir_positions.size() > 0:
			# every square but last is path
			for i in range(dir_positions.size() - 1):
				paths.append(dir_positions[i])
			# last is a target
			targets.append(dir_positions.back())
	return { "paths": paths, "targets": targets }

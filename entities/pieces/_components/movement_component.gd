class_name MovementComponent

extends Node

# Cache knight offsets once
static var KNIGHT_OFFSETS: Array[Vector2i] = compute_knight_offsets()

# Quick access to the piece and the board
@onready var piece : Piece = get_parent() as Piece
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
func get_all_moves(origin: Vector2i) -> Array[Vector2i]:
	var moves: Array[Vector2i] = []  # type: Array[Vector2i]

	# 1) Knights (L-shape) are a special case
	if piece.move_pattern == Enums.MovePattern.L_SHAPE:
		for offset in KNIGHT_OFFSETS:
			moves.append(origin + offset)
		return moves

	# 2) Everybody else uses directions
	var dirs := get_directions(piece.move_pattern)

	if piece.move_length == Enums.MoveLength.LONG:
		# Slide in each direction, stopping when we hit any piece
		var max_steps := piece.board.board_size
		for d in dirs:
			for step in range(1, max_steps):
				var pos := origin + d * step
				moves.append(pos)
				# If there's any piece here, stop further sliding
				if piece.board.piece_map.has(pos):
					break
	else:
		# SHORT: exactly 1 step, except pawn’s first move can be 2
		var max_steps := 1
		if _pawn_double_step_allowed(origin):
			max_steps = 2
		for d in dirs:
			for step in range(1, max_steps + 1):
				moves.append(origin + d * step)

	return moves
#
## Public API: returns Array of Vector2i legal destination coords
#func generate_moves(
	#board_pos   : Vector2i,
	#piece_map   : Dictionary[Vector2i, Piece],
	#board_size  : int
#) -> Array[Vector2i]:
	#var moves : Array[Vector2i] = []
#
	## 1) Get all base directions or offsets for our pattern
	#var dirs : Array[Vector2i] = get_directions(piece.move_pattern)
#
	#for d in dirs:
		#if piece.move_style == Enums.MoveStyle.JUMP:
			## single‐step jump (knight, pawn captures, etc.)
			#var target : Vector2i = board_pos + d
			#if _inside_board(target, board_size):
				#_maybe_add_move(board_pos, target, piece_map, moves)
		#else:
			## slide: keep stepping until blocked or reach limit
			## Determine how many steps we’ll take in this direction
			#var steps: int
			#if piece.move_length == Enums.MoveLength.SHORT:
				#steps = 1
			#else:
				#steps = board_size
#
			#var current : Vector2i = board_pos
			#for i in range(steps):
				#current += d
				#if not _inside_board(current, board_size):
					#break
				#if not _maybe_add_move(board_pos, current, piece_map, moves):
					#break  # blocked by a friendly or after an enemy capture
#
	#return moves
#
## Public API: returns the path (list of intermediate coords) from start→end
## Useful for move animations.
#func compute_path(
	#start : Vector2i,
	#end   : Vector2i
#) -> Array[Vector2i]:
	#var path : Array[Vector2i] = []
	#var delta := end - start
	## derive a unit‐step in the correct direction
	#var step := Vector2i(sign(delta.x), sign(delta.y))
	## knights/jumps have no path
	#if piece.move_style == Enums.MoveStyle.JUMP:
		#return path
#
	#var current := start + step
	#while current != end:
		#path.append(current)
		#current += step
	#return path
#
#
#
#func scan_legal_tiles() -> Array:
	#var tiles := []
	#return tiles
#
#
#func move_to_position(world_pos: Vector3) -> void:
	## Move the parent Piece to the target position in world space
	#get_parent().global_transform.origin = world_pos
	#
## Attempts to add `target` to `out` if legal.
## Returns `true` if we should continue sliding past this tile;
## `false` if we must stop (friendly block or after capture).
#func _maybe_add_move(
	#from : Vector2i,
	#target : Vector2i,
	#piece_map : Dictionary[Vector2i, Piece],
	#moves : Array[Vector2i]
#) -> bool:
	#var occupant: Piece = piece_map.get(target, null)
	#if occupant == null:
		#moves.append(target)
		#return true      # empty square: can continue sliding
	#elif occupant.piece_color != piece.piece_color:
		## enemy capture
		#moves.append(target)
		#return false     # stop after capturing
	#else:
		## friendly block
		#return false     # cannot move here, and stops slide
#
#func _inside_board(cell: Vector2i, size: int) -> bool:
	#return cell.x >= 0 and cell.x < size and cell.y >= 0 and cell.y < size

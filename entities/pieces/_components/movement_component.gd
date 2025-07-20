class_name MovementComponent

extends Node

# Quick access to the piece and the board
@onready var piece := get_parent()
var board : Board
var move_data: MovementData

#— Helpers —#

func get_all_directions() -> Array[Vector2i]:
	var dirs: Array[Vector2i] = []
	match move_data.pattern:
		Enums.MovePattern.STRAIGHT:
			dirs = [
				Enums.dir_to_vector(Enums.Direction.UP),
				Enums.dir_to_vector(Enums.Direction.DOWN),
				Enums.dir_to_vector(Enums.Direction.LEFT),
				Enums.dir_to_vector(Enums.Direction.RIGHT)
			]
		Enums.MovePattern.DIAGONAL:
			dirs = [
				Enums.dir_to_vector(Enums.Direction.UP_LEFT),
				Enums.dir_to_vector(Enums.Direction.UP_RIGHT),
				Enums.dir_to_vector(Enums.Direction.DOWN_LEFT),
				Enums.dir_to_vector(Enums.Direction.DOWN_RIGHT)
			]
		Enums.MovePattern.ALL_DIRS:
			dirs = [
				Enums.dir_to_vector(Enums.Direction.UP),
				Enums.dir_to_vector(Enums.Direction.DOWN),
				Enums.dir_to_vector(Enums.Direction.LEFT),
				Enums.dir_to_vector(Enums.Direction.RIGHT),
				Enums.dir_to_vector(Enums.Direction.UP_LEFT),
				Enums.dir_to_vector(Enums.Direction.UP_RIGHT),
				Enums.dir_to_vector(Enums.Direction.DOWN_LEFT),
				Enums.dir_to_vector(Enums.Direction.DOWN_RIGHT)
			]
		Enums.MovePattern.SINGLE_DIR:
			dirs = [Enums.dir_to_vector(Enums.Direction.UP)]
		_:
			dirs = []
	return dirs

func _pawn_double_step_allowed(origin: Vector2i) -> bool:
	if piece.piece_type != Enums.PieceType.PAWN:
		return false
	if piece.has_moved:
		return false
	return true

func piece_forward_dir() -> int:
	if piece.player_controlled:
		return 1
	else:
		return -1

#— Public API —#
func get_all_moves(origin: Vector2i) -> Dictionary:
	var paths: Array[Vector2i] = []
	var move_targets: Array[Vector2i] = []
	var attack_targets: Array[Vector2i] = []
	
	var vectors: Array[Vector2i] = []
	var is_custom_shape: bool = move_data.shape_resource != null
	var is_first_move: bool = !piece.has_moved
	var pattern := move_data.pattern
	
	if pattern == Enums.MovePattern.SINGLE_DIR:
		# Always treat single-dir as "forward"
		var forward: Vector2i = piece.get_forward_dir()
		# Get single-step (and optionally double-step) from shape resource or fallback
		if move_data.shape_resource:
			for v in move_data.shape_resource.get_vectors():
				vectors.append(Vector2i(v.x * forward.x, v.y * forward.y))
		else:
			# fallback: classic pawn move
			vectors.append(Vector2i(0, 1) * forward.y)
		# Double move on first turn? (e.g., pawn double step)
		if is_first_move and move_data.first_move_shape:
			for v in move_data.first_move_shape.get_vectors():
				vectors.append(Vector2i(v.x * forward.x, v.y * forward.y))
	
	else:
		if is_custom_shape:
			var dir_vec: Vector2i
			for dir: Enums.Direction in Enums.Direction.values():
				dir_vec = Enums.dir_to_vector(dir)
				vectors = move_data.shape_resource.get_vectors()
				
			vectors = move_data.shape_resource.get_vectors()
		# NOTE: Optionally, rotate/mirror these for all valid directions here if needed
		else:
			vectors = get_all_directions() # straight, diag, etc.

# 2. Calculate moves
	match move_data.style:
		Enums.MoveStyle.JUMP:
			for vector in vectors:
				var pos: Vector2i = origin + vector
				if not board.has_tile(pos):
					continue
				if board.has_piece_at(pos):
					var occupant: Piece = board.get_piece_at(pos)
					if not occupant.is_friend(piece.alliance):
						attack_targets.append(pos)
					continue
				move_targets.append(pos)
				
		Enums.MoveStyle.SLIDE:
			var max_steps: int = board.get_size() if move_data.length == Enums.MoveLength.LONG else 1
			for vector in vectors:
				var breadcrumbs: Array[Vector2i] = []
				for step in range(1, max_steps + 1):
					var pos: Vector2i = origin + vector * step
					if not board.has_tile(pos):
						break
					breadcrumbs.append(pos)
					if board.has_piece_at(pos):
						var occupant: Piece = board.get_piece_at(pos)
						if occupant.is_friend(piece.alliance):
							# Friendly: previous breadcrumb (if any) is a move target
							if breadcrumbs.size() == 1:
								breadcrumbs.clear()
							if breadcrumbs.size() >= 1:
								move_targets.append(breadcrumbs[-1])
							# Stop in this direction
							break
						else:
							# Enemy: this position is an attack target
							attack_targets.append(pos)
							# Stop in this direction
							break
				# Optionally, collect paths if you want a visual trail up to last checked position
				paths.append_array(breadcrumbs)
	return {
		Enums.HighlightType.PATH: paths,
		Enums.HighlightType.MOVE: move_targets,
		Enums.HighlightType.ATTACK: attack_targets
	}
	## 1) Knights (L-shape) are a special case
	#if piece.move_pattern == Enums.MovePattern.L_SHAPE:
		#for offset in Const.KNIGHT_OFFSETS:
			#var pos: Vector2i = origin + offset
			#if not board.has_tile(pos): # Stop within boundaries of the board
				#continue
			#var marker: TileMarker = board.get_marker(pos)
			#if board.has_marker(marker):  # Don't include in new calculations if it's part of the currently selected
				#continue
			#if board.has_piece_at(pos):
				#var occupant: Piece = board.get_piece_at(pos)
				#if not occupant.is_friend(piece.alliance):
					#attack_targets.append(pos)
				#continue
			#move_targets.append(pos)
		#return { "paths": paths, "move_targets": move_targets, "attack_targets": attack_targets  }
#
	## --- 2. Pawns (custom handling for movement/capture/en passant if you want)
	#if piece.piece_type == Enums.PieceType.PAWN:
		#var fwd := Vector2i(0, piece_forward_dir())
		#var one_step: Vector2i = origin + fwd
		## Forward move if not blocked
		#if board.has_tile(one_step) and not board.has_piece_at(one_step):
			#paths.append(one_step)
			#move_targets.append(one_step)
	## Double-step from initial square
			#if _pawn_double_step_allowed(origin):
				#var two_step: Vector2i = origin + fwd * 2
				#if board.has_tile(two_step) and not board.has_piece_at(two_step):
					#paths.append(two_step)
					#move_targets.append(two_step)
		## Captures: forward-diagonals
		#for side: int in [-1, 1]:
			#var capture_pos: Vector2i = origin + Vector2i(side, piece_forward_dir())
			#if board.has_tile(capture_pos) and board.has_piece_at(capture_pos):
			## Must be enemy color!
				#var target_piece = board.piece_map[capture_pos]
				#if target_piece.piece_color != piece.piece_color:
					#move_targets.append(capture_pos)
		#return { "paths": paths, "move_targets": move_targets, "attack_targets": attack_targets  }
	#
	## 2) Everybody else uses directions
	#var dirs := get_directions(piece.move_pattern)
	#
##region Step Calculation
	#var is_long : bool
	#if piece.move_length == Enums.MoveLength.LONG:
		#is_long = true
	#else:
		#is_long = false
	#var max_steps : int
	#if is_long:
		#max_steps = piece.board.board_size
	#else:
		#max_steps = 1
	#if not is_long and _pawn_double_step_allowed(origin):
		#max_steps = 2
##endregion
	#
	#for d in dirs:
		#var dir_positions: Array[Vector2i] = []
		#for step in range(1, max_steps + (0 if is_long else 1)):
			#var pos := origin + d * step
			#var marker: TileMarker = piece.board.tile_markers.get(pos, null)
			#if not piece.board.tile_grid_positions.has(pos): # Stop within boundaries of the board
				#break
			#if piece.board.active_markers.has(marker):  # Don't include in new calculations if it's part of the currently selected
				#continue
			#if piece.board.piece_map.has(pos):
				#if piece.piece_color == piece.board.enemy_color:
					#move_targets.append(pos)
				#break
			#else:
				#dir_positions.append(pos)
		## once done with this dir, move all but last into paths, last into targets
		#if dir_positions.size() > 0:
			## every square but last is path
			#for i in range(dir_positions.size() - 1):
				#paths.append(dir_positions[i])
			## last is a target
			#targets.append(dir_positions.back())
	#return { "paths": paths, "move_targets": move_targets, "attack_targets": attack_targets  }

func get_board(_board: Board) -> void:
	board = _board


func get_move_data(_move_data: MovementData) -> void:
	move_data = _move_data

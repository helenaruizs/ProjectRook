class_name HighlightedState

extends State

func enter() -> void:
	piece.moves = piece.movement.get_all_moves(piece.board_pos)
	piece.is_hovered = true
	piece.emit_signal("piece_hovered", piece, piece.board_pos, piece.moves)
	# TEST: Printing hl piece moves
	#print(piece.moves)

func exit() -> void:
	#piece.emit_signal("piece_hovered_exit", piece, piece.board_pos, piece.moves)
	piece.is_hovered = false

func handle_condition(cond: int) -> void:
	if cond == Enums.Conditions.HOVER_EXIT:
		machine.change_state(Enums.States.IDLE)
	if cond == Enums.Conditions.SELECTED:
		machine.change_state(Enums.States.SELECTED)

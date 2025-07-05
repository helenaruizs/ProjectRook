class_name IdleState

extends State

func enter() -> void:
	if piece.moves.size() != 0:
		piece.moves = piece.movement.get_all_moves(piece.board_pos)
	# If we re-entered Idle but the mouse is still over us,
	# go right back to Highlighted.
	piece.is_hovered = false
	piece.emit_signal("piece_hovered_exit", piece, piece.board_pos, piece.moves)
		
func handle_condition(cond: int) -> void:
	if cond == Enums.Conditions.HOVER_ENTER:
		machine.change_state(Enums.States.HIGHLIGHTED)

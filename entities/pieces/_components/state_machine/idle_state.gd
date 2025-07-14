class_name IdleState

extends State

func enter() -> void:
	piece.set_hovered(false)
	piece.set_selected(false)

func handle_interaction(event_type: Enums.InteractionType) -> void:
	match event_type:
		Enums.InteractionType.SELECT:
			machine.change_state(Enums.States.SELECTED)
		Enums.InteractionType.HOVER_IN:
			machine.change_state(Enums.States.HIGHLIGHTED)
		Enums.InteractionType.HOVER_OUT:
			pass
		_:
			pass
	#if piece.moves.size() != 0:
		#piece.moves = piece.movement.get_all_moves(piece.board_pos)
	## If we re-entered Idle but the mouse is still over us,
	## go right back to Highlighted.
	#piece.is_hovered = false
	#piece.emit_signal("piece_hovered_exit")
		#
#func handle_condition(cond: int) -> void:
	#if cond == Enums.Conditions.HOVER_ENTER:
		#machine.change_state(Enums.States.HIGHLIGHTED)

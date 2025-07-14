class_name HighlightedState

extends State

func enter() -> void:
	piece.set_hovered(true)
#
#func exit() -> void:
	##piece.emit_signal("piece_hovered_exit", piece, piece.board_pos, piece.moves)
	#piece.is_hovered = false
#
func handle_interaction(event_type: Enums.InteractionType) -> void:
	match event_type:
		Enums.InteractionType.SELECT:
			SignalBus.emit_signal("piece_input", Enums.InteractionType.SELECT, piece)
			machine.change_state(Enums.States.SELECTED)
		Enums.InteractionType.HOVER_OUT:
			SignalBus.emit_signal("piece_input", Enums.InteractionType.HOVER_OUT, piece)
			machine.change_state(Enums.States.IDLE)
		_:
			pass

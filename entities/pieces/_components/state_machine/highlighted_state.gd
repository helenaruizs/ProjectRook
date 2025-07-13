class_name HighlightedState

extends State

func enter() -> void:
	piece.is_piece_hovered(true)
	print("Highlighted")
#
#func exit() -> void:
	##piece.emit_signal("piece_hovered_exit", piece, piece.board_pos, piece.moves)
	#piece.is_hovered = false
#
func handle_interaction(event_type: Enums.InteractionType) -> void:
	match event_type:
		Enums.InteractionType.SELECT:
			machine.change_state(Enums.States.SELECTED)
		Enums.InteractionType.HOVER_OUT:
			machine.change_state(Enums.States.IDLE)
		_:
			pass

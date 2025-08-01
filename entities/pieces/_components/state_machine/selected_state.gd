class_name SelectedState

extends State

func enter() -> void:
	pass


func handle_interaction(event_type: Enums.InteractionType) -> void:
	match event_type:
		Enums.InteractionType.SELECT:
			machine.change_state(Enums.States.HIGHLIGHTED)
		Enums.InteractionType.HOVER_IN:
			pass
		Enums.InteractionType.HOVER_OUT:
			pass
		Enums.InteractionType.DESELECT:
			machine.change_state(Enums.States.IDLE)
		_:
			pass
#
#func exit() -> void:
	#piece.emit_signal("piece_selected_exit", piece, piece.board_pos, piece.moves)
	#piece.is_selected = false
#
#func handle_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton and event.pressed:
		#if piece.is_hovered:
			#machine.change_state(Enums.States.HIGHLIGHTED)
		#elif not piece.is_hovered:
			#machine.change_state(Enums.States.IDLE) 

class_name SelectedState

extends State

func enter() -> void:
	piece.is_selected = true
	piece.moves = piece.movement.get_all_moves(piece.board_pos)
	
	print("This is from the Selected State")
	piece.emit_signal("piece_selected", piece, piece.board_pos, piece.moves)

func exit() -> void:
	piece.emit_signal("piece_selected_exit", piece, piece.board_pos, piece.moves)
	piece.is_selected = false

func handle_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if piece.is_hovered:
			machine.change_state(Enums.States.HIGHLIGHTED)
		elif not piece.is_hovered:
			machine.change_state(Enums.States.IDLE) 

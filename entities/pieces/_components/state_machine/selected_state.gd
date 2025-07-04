class_name SelectedState

extends State

func enter() -> void:
	piece.emit_signal("piece_selected", piece, piece.board_pos)

func exit() -> void:
	piece.emit_signal("piece_selected_exit", piece, piece.board_pos)

func handle_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		machine.change_state(Enums.States.IDLE)

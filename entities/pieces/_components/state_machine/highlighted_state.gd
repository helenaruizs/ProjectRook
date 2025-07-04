class_name HighlightedState

extends State

func enter() -> void:
	piece.emit_signal("piece_hovered", piece, piece.board_pos)

func exit() -> void:
	piece.emit_signal("piece_hovered_exit", piece, piece.board_pos)

func handle_condition(cond: int) -> void:
	if cond == Enums.Conditions.HOVER_EXIT:
		machine.change_state(Enums.States.IDLE)

func handle_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		machine.change_state(Enums.States.SELECTED)

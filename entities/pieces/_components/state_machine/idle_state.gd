class_name IdleState

extends State

func handle_condition(cond: int) -> void:
	if cond == Enums.Conditions.HOVER_ENTER:
		machine.change_state(Enums.States.HIGHLIGHTED)

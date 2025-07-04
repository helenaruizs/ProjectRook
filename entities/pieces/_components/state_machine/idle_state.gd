class_name IdleState

extends State

func enter() -> void:
	# If we re-entered Idle but the mouse is still over us,
	# go right back to Highlighted.
	piece.is_hovered = false
		
func handle_condition(cond: int) -> void:
	if cond == Enums.Conditions.HOVER_ENTER:
		machine.change_state(Enums.States.HIGHLIGHTED)

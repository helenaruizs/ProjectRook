class_name HighlightedState

extends State

func handle_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		machine.change_state(States.SELECTED)

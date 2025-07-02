class_name SelectedState

extends State

func handle_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		machine.change_state(Enums.States.IDLE)

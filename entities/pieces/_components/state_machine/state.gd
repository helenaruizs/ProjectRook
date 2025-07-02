class_name State
# Base class for all piece states using the “direct push” API.
# States call `machine.change_state(...)` to move to the next state.

extends Node

enum States {
	IDLE,
	HIGHLIGHTED,
	SELECTED,
	MOVING,
}

# Reference to the parent StateMachine
var machine: StateMachine

# State's name for quicker referencing
@export var state_id : States

# Called once, immediately after this state node has been added as a child of the StateMachine.
# The argument is the StateMachine instance, so states can invoke:
#   machine.change_state(NextState.new())
func enter() -> void:
	# FIXME: Debug
	# Print this state’s class_name to the console
	var name_to_print : String = Enums.enum_to_string(States, state_id)
	print("Entering state:", name_to_print)

# Called just before this state is removed. Override to clean up.
func exit() -> void:
	pass

# Called from StateMachine._input() only on the active state.
# Override to react to InputEvents. To change state, call:
#   machine.change_state(NextState.new())
func handle_input(event: InputEvent) -> void:
	pass

# Called from StateMachine._physics_process() only on the active state.
# Override for per-frame physics logic. To change state, call:
#   machine.change_state(NextState.new())
func physics_state_process(delta: float) -> void:
	pass

# Called from StateMachine._process() only on the active state.
# Override for non-physics per-frame logic.
# To change state, call:
#   machine.change_state(NextState.new())
func state_process(delta: float) -> void:
	pass

# Condition handler
func handle_condition(cond: int) -> void:
	pass

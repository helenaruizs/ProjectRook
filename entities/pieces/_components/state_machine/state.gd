extends Node
class_name State

var next_state: State = null
var playback: AnimationNodeStateMachinePlayback #TODO: Animation system

var debug_label : String = "test" # FIXME: Did this to debug the states

# This base enter() resets the transition guard.
func enter(previous_state: State) -> void:
	pass

func exit() -> void:
	# Optional: clear any state-specific variables
	pass

# Use this helper to finish the state. It will only emit the finished signal once.
func finish(next_state: State) -> void:
	pass

# Called on unhandled input events.
func handle_input(_event: InputEvent) -> void:
	pass

# Called on every main loop tick.
func update(_delta: float) -> void:
	pass

# Called on every physics update tick.
func physics_update(_delta: float) -> void:
	pass

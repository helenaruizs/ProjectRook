class_name State
# Base class for all piece states using the “direct push” API.
# States call `machine.change_state(...)` to move to the next state.

extends Node

# NOTE: To call the next state, use machine.change_state(next_state : Enum.States)

# State's name for quicker referencing
@export var state_id : Enums.States

# Reference to the parent StateMachine
var machine: StateMachine

# Reference to the parent piece
var piece : Piece

# Called once, immediately after this state node has been added as a child of the StateMachine.
func enter() -> void:
	# TEST: Print State name
	# Print this state’s class_name to the console
	#var name_to_print : String = Enums.enum_to_string(Enums.States, state_id)
	#print("Entering state:", name_to_print)
	pass
	
# Called just before this state is removed. Override to clean up.
func exit() -> void:
	pass

# Called from StateMachine._input() only on the active state.
# Override to react to InputEvents.
func handle_input(event: InputEvent) -> void:
	pass

# Called from StateMachine._physics_process() only on the active state.
# Override for per-frame physics logic.
func physics_state_process(delta: float) -> void:
	pass

# Called from StateMachine._process() only on the active state.
# Override for non-physics per-frame logic.
func state_process(delta: float) -> void:
	pass

# Condition handler, signal based
func handle_condition(cond: Enums.Conditions) -> void:
	pass


func handle_interaction(event_type: Enums.InteractionType) -> void:
	pass
	#match event_type:
		#Enums.InteractionType.SELECT:
			#print("Piece selected: %s" % [self.name])
			#SignalBus.emit_signal("piece_selected", self)
		#Enums.InteractionType.HOVER_IN:
			#print("Piece hovered: %s" % [self.name])
			#piece.is_hovered = true
		#Enums.InteractionType.HOVER_OUT:
			#print("Piece UN-hovered: %s" % [self.name])
			#piece.is_hovered = false

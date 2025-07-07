class_name StateMachine

extends Node

signal state_changed(piece: Piece, new_state: Enums.States)

@export var starting_state: State = null
@export var is_player_controlled: bool = false
# The code bellow is something called an “immediately‐invoked function expression”
#(IIFE) in GDScript: you define a tiny anonymous function right where you need it,
#then immediately call it to compute your default value
# NOTE: Immediate style of function calling, useful
@onready var current_state: State = (func get_initial_state() -> State:
	return starting_state if starting_state != null else get_child(0)
).call()

var state_nodes: Dictionary[Enums.States, NodePath] = {}
var animation_tree : AnimationTree = null # TODO: Animation tree for the pieces


func _ready() -> void:
#region Child States Setup
	# Dynamically setup the children states
	for state_node: State in find_children("*", "State"): # "*" is a glob-style pattern on the node’s name. * by itself matches every name.
		# Wire up state machine for direct calls to change states
		state_node.machine = self
		state_node.piece = self.get_parent()
		
		# Populate dictionary for quick state calls
		var key : Enums.States = state_node.state_id
		var path : NodePath = get_path_to(state_node)
		state_nodes[key] = path
		
	if state_nodes.size() == 0:
		push_warning("States in State Machine were not configured")
	# TEST: Print state nodes

	#print(state_nodes)
	
#endregion

	await owner.ready
	current_state.enter()
	
	
func change_state(new_state: Enums.States) -> void:
	var previous_state := current_state
	var next_state := state_nodes[new_state]
	var piece := get_parent() as Piece
	current_state = get_node(next_state)
	previous_state.exit()
	current_state.enter()
	# TEST: Printing marker info for debug
	#print(piece.board.active_piece)
	#print(piece.board.active_markers)
	emit_signal("state_changed", piece, new_state)

func is_current_state(state_enum: Enums.States) -> bool:
	# get the StateNode for this enum (or null if it doesn't exist)
	var node_for_enum : NodePath = state_nodes.get(state_enum, null)
	# compare to the machine's current_state
	return get_node(node_for_enum) == current_state
	
func _process(delta: float) -> void:
	if current_state != null:
		current_state.state_process(delta)


func _input(event: InputEvent) -> void:
	if current_state != null:
		current_state.handle_input(event)


func on_condition(cond: int) -> void:
	# give your current state a chance to handle it
	current_state.handle_condition(cond)

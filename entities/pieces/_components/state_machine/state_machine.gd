class_name StateMachine

extends Node

@export var starting_state: State
# The code bellow is something called an “immediately‐invoked function expression”
#(IIFE) in GDScript: you define a tiny anonymous function right where you need it,
#then immediately call it to compute your default value
@onready var current_state: State = (func get_initial_state() -> State:
	return starting_state if starting_state != null else get_child(0)
).call()

var state_nodes: Dictionary[State.States, NodePath] = {}
var animation_tree : AnimationTree = null # TODO: Animation tree for the pieces


func _ready() -> void:
#region Child States Setup
	# Dynamically setup the children states
	for state_node: State in find_children("*", "State"): # "*" is a glob-style pattern on the node’s name. * by itself matches every name.
		# Wire up state machine for direct calls to change states
		state_node.machine = self
		
		# Populate dictionary for quick state calls
		var key : State.States = state_node.state_id
		var path : NodePath = get_path_to(state_node)
		state_nodes[key] = path
		
	if state_nodes.size() == 0:
		push_warning("States in State Machine were not configured")	
	# FIXME: Debug

	print(state_nodes)
	
#endregion

	await owner.ready
	current_state.enter()
	
	
func change_state(new_state: State.States) -> void:
	var previous_state := current_state.name
	var next_state := state_nodes[new_state]
	current_state = get_node(next_state)
	current_state.enter()


func _process(delta: float) -> void:
	if current_state != null:
		current_state.state_process(delta)

func _input(event: InputEvent) -> void:
	if current_state != null:
		current_state.handle_input(event)

class_name StateMachine

extends Node

enum States {
	IDLE,
	HIGHLIGHTED,
	SELECTED,
	MOVING,
}

@export var state_scripts: Dictionary[States, Script]
@export var starting_state: States  # the enum value you want to start in
@onready var current_state: State = null

var animation_tree : AnimationTree = null # TODO: Animation tree for the pieces

# Sensible state defaults
func _init() -> void:
	if state_scripts.size() == 0:
		push_warning("States in State Machine were not configured")
		state_scripts = {
			States.IDLE: preload("res://entities/pieces/_components/state_machine/idle_state.gd"),
			States.HIGHLIGHTED: preload("res://entities/pieces/_components/state_machine/highlighted_state.gd"),
			States.SELECTED: preload("res://entities/pieces/_components/state_machine/selected_state.gd"),
			States.MOVING: preload("res://entities/pieces/_components/state_machine/moving_state.gd"),
		}

func _ready() -> void:
	
	# === ENTER INITIAL STATE ===
	var state_id: States = starting_state
	if not state_scripts.has(state_id):
		state_id = state_scripts.keys()[0] as States

	# Instantiate and enter the initial state
	var state_script: GDScript = state_scripts.get(starting_state, null)
	if state_script == null:
		push_error("StateMachine: no script for starting_state %s" % starting_state)
		return

# `.new()` constructs a fresh instance of your state class
	var inst: Node = state_script.new()
	if not inst is State:
		push_error("StateMachine: script for %s is not a PieceState" % starting_state)
		return

	change_state(inst as State)

func change_state(new_state: State) -> void:
	# Tear down the old state
	if current_state != null:
		current_state.exit()
		current_state.set_process(false)
		current_state.set_process_input(false)
		remove_child(current_state)

	# Install the new state
	current_state = new_state
	add_child(current_state)
	current_state.set_process(true)
	current_state.set_process_input(true)

	# Initialize it
	current_state.enter(self)
	
	# FIXME: For debugging purposes only
	print(current_state)

func _process(delta: float) -> void:
	if current_state != null:
		current_state.state_process(delta)

func _input(event: InputEvent) -> void:
	if current_state != null:
		current_state.handle_input(event)

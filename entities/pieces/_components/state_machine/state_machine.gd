class_name StateMachine

extends Node

@onready var label_3d := $Label3D # FIXME: This was for debugging only!

enum States {
	IDLE,
	HIGHLIGHTED,
	SELECTED,
	MOVING,
}

@export var state_scripts: Dictionary[States, Script]

@onready var current_state: State  = starting_state

var starting_state: State = null ## Hook up to the initial state (usually idle)
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
	pass

func _unhandled_input(event: InputEvent) -> void:
	current_state.handle_input(event)


func _process(delta: float) -> void:
	current_state.update(delta)


func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)

#Here’s the _transition_to_next_state() function. It changes the active state when the state emits the signal.
func _transition_to_next_state(target_state: String, data: Dictionary = {}) -> void:
	var new_state: State = null
	
	# If no matching state was found, print an error and return.
	if new_state == null:
		printerr(owner.name + ": Trying to transition to state " + target_state + " but it does not exist.")
		return

	var previous_state: State = current_state
	current_state.exit()
	current_state = new_state
	current_state.enter(previous_state)
	label_3d.text = current_state.debug_label

class_name Piece

extends Node3D

signal piece_hovered(piece: Piece, board_pos: Vector2i, moves: Dictionary)
signal piece_hovered_exit()
signal piece_selected(piece: Piece, board_pos: Vector2i, moves: Dictionary)
signal piece_selected_exit(piece: Piece, board_pos: Vector2i, moves: Dictionary)

@export var piece_type : Enums.PieceType

@export_subgroup("Basic Nodes Setup")
@export var visuals : VisualsComponent
@export var movement : MovementComponent
@export var stats : StatsComponent
@export var modifiers : ModifiersComponent
@export var state_machine : StateMachine


@export_subgroup("Movement Properties")
@export var move_style : Enums.MoveStyle
@export var move_pattern : Enums.MovePattern
@export var move_length : Enums.MoveLength

var piece_color : Enums.FactionColor
var board_pos : Vector2i

var moves: Dictionary = {}
var has_moved: bool = false
var is_hovered: bool = false
var is_selected: bool = false
var board : Board

# NOTE: Signal subscriptions are being derrived from the Game Manager, for differentiation between player and opponent pieces

func update_visuals(tex : Texture2D) -> void:
	visuals.set_texture(tex)

func update_position(world_pos: Vector3) -> void:
	if movement != null:
		movement.move_to_position(world_pos)

func _on_condition(cond: Enums.Conditions) -> void:
	# forward the semantic event to your FSM
	state_machine.on_condition(cond)

func _on_state_changed(piece: Piece, new_state: Enums.States) -> void:
	visuals.on_state_changed(new_state)

func _on_piece_hover(tile_marker: TileMarker, piece: Piece) -> void :
	if not state_machine.is_current_state(Enums.States.SELECTED):
		state_machine.change_state(Enums.States.HIGHLIGHTED)
	
func _on_piece_hover_out(tile_marker: TileMarker, piece: Piece) -> void :
	if state_machine.is_current_state(Enums.States.HIGHLIGHTED):
		state_machine.change_state(Enums.States.IDLE)

func _on_piece_selected() -> void :
	print("This is from the Piece")
	state_machine.change_state(Enums.States.SELECTED)

func _on_piece_selected_out() -> void :
	state_machine.change_state(Enums.States.IDLE)

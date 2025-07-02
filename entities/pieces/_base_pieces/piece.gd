class_name Piece

extends Node3D

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

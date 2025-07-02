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

func _ready() -> void:
	# Signal Subscriptions
	EventBus.connect("piece_hovered", Callable(self, "_on_piece_hovered"))

func update_visuals(tex : Texture2D) -> void:
	visuals.set_texture(tex)

func update_position(world_pos: Vector3) -> void:
	if movement != null:
		movement.move_to_position(world_pos)


func _on_piece_hovered(piece: Piece, coord: Vector2i) -> void:
	# Ignore hovers meant for other pieces
	if piece != self:
		return

	# Tell *this* piece’s FSM to highlight
	state_machine.change_state(State.States.HIGHLIGHTED)

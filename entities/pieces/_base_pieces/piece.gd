class_name Piece

extends Node3D

@export var piece_type : Enums.PieceType

@export_subgroup("Basic Nodes Setup")
@export var visuals : VisualsComponent
@export var movement : MovementComponent
@export var stats : StatsComponent
@export var modifiers : ModifiersComponent


@export_subgroup("Movement Properties")
@export var move_style : Enums.MoveStyle
@export var move_pattern : Enums.MovePattern
@export var move_length : Enums.MoveLength

var board_pos : Vector2i

func update_visuals(tex : Texture2D) -> void:
	visuals.set_texture(tex)
	

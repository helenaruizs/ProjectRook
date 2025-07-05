class_name TileMarker

extends Node3D

@export var state: Enums.TileStates = Enums.TileStates.NORMAL
@onready var mesh: MeshInstance3D = $MarkerMesh

@export_category("Materials")
@export var mat_normal: Material
@export var mat_legal_move: Material
@export var mat_legal_hovered: Material
@export var mat_selected_piece: Material
@export var mat_move_path: Material
@export var mat_hovered: Material
@export var mat_occupied_player: Material
@export var mat_occupied_opponent: Material
@export var mat_target: Material
@export var mat_occupied_player_selected: Material
@export var mat_occupied_opponent_selected: Material
@export var mat_target_selected: Material
@export var mat_move_path_selected: Material
@export var mat_selected_piece_selected: Material

# Build a lookup once
@onready var _materials: Dictionary = {
	Enums.TileStates.NORMAL: mat_normal,
	Enums.TileStates.LEGAL_MOVE: mat_legal_move,
	Enums.TileStates.LEGAL_MOVE_HOVERED: mat_legal_hovered,
	Enums.TileStates.SELECTED_PIECE: mat_selected_piece,
	Enums.TileStates.MOVE_PATH: mat_move_path,
	Enums.TileStates.HOVERED: mat_hovered,
	Enums.TileStates.OCCUPIED_PLAYER: mat_occupied_player,
	Enums.TileStates.OCCUPIED_OPPONENT: mat_occupied_opponent,
	Enums.TileStates.TARGET: mat_target,
	Enums.TileStates.OCCUPIED_PLAYER_SELECTED: mat_occupied_player,
	Enums.TileStates.OCCUPIED_OPPONENT_SELECTED: mat_occupied_opponent,
	Enums.TileStates.TARGET_SELECTED: mat_target,
	Enums.TileStates.MOVE_PATH_SELECTED: mat_move_path,
	Enums.TileStates.SELECTED_PIECE_SELECTED: mat_selected_piece_selected,
}

const SELECTED_STATE_MAP := {
	Enums.TileStates.MOVE_PATH: Enums.TileStates.MOVE_PATH_SELECTED,
	Enums.TileStates.TARGET: Enums.TileStates.TARGET_SELECTED,
	Enums.TileStates.OCCUPIED_PLAYER: Enums.TileStates.OCCUPIED_PLAYER_SELECTED,
	Enums.TileStates.OCCUPIED_OPPONENT: Enums.TileStates.OCCUPIED_OPPONENT_SELECTED,
	Enums.TileStates.SELECTED_PIECE: Enums.TileStates.SELECTED_PIECE_SELECTED,
}


func _ready() -> void:
	mesh.hide()

func set_state(new_state: int) -> void:
	state = new_state

	if state == Enums.TileStates.NORMAL:
		# Hide the marker entirely
		mesh.hide()
	else:
		# Show the marker and apply the right material
		mesh.show()
		var mat: Material = _materials.get(state, mat_normal)
		mesh.material_override = mat

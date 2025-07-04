class_name TileMarker

extends Node3D

@export var state: Enums.TileStates = Enums.TileStates.NORMAL
@onready var mesh: MeshInstance3D = $MarkerMesh

@export_category("Materials")
@export var mat_normal           : Material
@export var mat_legal_move       : Material
@export var mat_legal_hovered    : Material
@export var mat_selected         : Material
@export var mat_move_path        : Material
@export var mat_hovered          : Material
@export var mat_occupied_player  : Material
@export var mat_occupied_opponent: Material

# Build a lookup once
@onready var _materials: Dictionary = {
	Enums.TileStates.NORMAL:            mat_normal,
	Enums.TileStates.LEGAL_MOVE:        mat_legal_move,
	Enums.TileStates.LEGAL_MOVE_HOVERED: mat_legal_hovered,
	Enums.TileStates.SELECTED:          mat_selected,
	Enums.TileStates.MOVE_PATH:         mat_move_path,
	Enums.TileStates.HOVERED:           mat_hovered,
	Enums.TileStates.OCCUPIED_PLAYER:   mat_occupied_player,
	Enums.TileStates.OCCUPIED_OPPONENT: mat_occupied_opponent,
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

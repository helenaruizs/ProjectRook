class_name TileMarker

extends Node3D

@export var state: Enums.TileStates = Enums.TileStates.NORMAL
@onready var mesh: MeshInstance3D = $MarkerMesh

func set_state(new_state: int) -> void:
	state = new_state
	match state:
		Enums.TileStates.NORMAL:
			mesh.visible = false
		Enums.TileStates.LEGAL_MOVE:
			mesh.visible = true
			mesh.material_override.albedo_color = Color(0,1,0, 0.5)
		Enums.TileStates.LEGAL_MOVE_HOVERED:
			mesh.visible = true
			mesh.material_override.albedo_color = Color(1,1,0, 0.75)
		Enums.TileStates.SELECTED:
			mesh.visible = true
			mesh.material_override.albedo_color = Color(1,0,1, 0.75)
		Enums.TileStates.MOVE_PATH:
			mesh.visible = true
			mesh.material_override.albedo_color = Color(0,0,1, 0.5)
		Enums.TileStates.HOVERED:
			mesh.visible = true
			mesh.material_override.albedo_color = Color(1,1,1, 0.5)
		Enums.TileStates.OCCUPIED_PLAYER:
			mesh.visible = true
			mesh.material_override.albedo_color = Color(1,0,0, 0.5)  # red for your own piece
		Enums.TileStates.OCCUPIED_OPPONENT:
			mesh.visible = true
			mesh.material_override.albedo_color = Color(0.5,0,0, 0.75) # dark red for capture

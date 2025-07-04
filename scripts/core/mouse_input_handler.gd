class_name MouseInputHandler

extends Node

@export var camera_path : NodePath
@export var board_path  : NodePath

@onready var camera : Camera3D = get_node(camera_path) as Camera3D
@onready var board  : Board    = get_node(board_path)  as Board

var ray_length : float = Const.RAY_LENGTH

# TEST: Using a debug key and function to test the ray cast
func _unhandled_input(event: InputEvent) -> void:
	var screen_pos := camera.get_viewport().get_mouse_position()
	if DebugUtils.debug_key(event):
		var hit : Dictionary= cast_ray(screen_pos)
		if hit.size() == 0:
			print_debug("[Debug] Ray at ", screen_pos, " hit nothing.")
		else:
			print_debug("[Debug] Ray at ", screen_pos, " →",
						"\n    collider: ", hit.collider,
						"\n    position: ", hit.position,
						"\n    normal:   ", hit.normal)
					
#func _input(event: InputEvent) -> void:
	#if event is InputEventMouseMotion:
		#var tile := get_tile_under_mouse(event.position)
		#if tile != null:
			#EventBus.emit_signal("tile_hovered", tile)
	#elif event is InputEventMouseButton and event.pressed:
		#var tile := get_tile_under_mouse(event.position)
		#if tile != null:
			#EventBus.emit_signal("tile_clicked", tile)

# Public API: returns the raw raycast result dictionary,
# or an empty dictionary if nothing was hit.
func cast_ray(screen_pos: Vector2) -> Dictionary:
	var from : Vector3 = camera.project_ray_origin(screen_pos)
	var to   : Vector3 = from + camera.project_ray_normal(screen_pos) * ray_length
	var space : PhysicsDirectSpaceState3D = get_viewport().get_world_3d().direct_space_state
	var params := PhysicsRayQueryParameters3D.new()
	params.from = from
	params.to   = to
	return space.intersect_ray(params)

# Public API: returns the board cell under `screen_pos`, or `null`
func get_tile_under_mouse(screen_pos: Vector2) -> Vector2i:
	var result := cast_ray(screen_pos)
	if result.size() <= 0:
		return Vector2i()
	# Only care if we hit the GridMap itself
	if result.collider != board.grid_map:
		return Vector2i()

	var world_pos : Vector3  = result.position
	var local_pos : Vector3  = board.grid_map.to_local(world_pos)
	var cell      : Vector3i = board.grid_map.local_to_map(local_pos)
	return Vector2i(cell.x, cell.z)

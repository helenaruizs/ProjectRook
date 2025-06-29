extends Node

const RAY_LENGTH: float = 1000.0

@export var camera_path : NodePath
@export var board_path: NodePath

var camera: Camera3D
var board: Board


# Track last hovered element to avoid repetitive signals
var last_hovered_coord: Vector2i = Vector2i(-999, -999)  # some invalid coord
var last_hovered_piece: Piece = null

func _ready() -> void:
	camera    = get_node(camera_path)   as Camera3D
	board  = get_node(board_path)  as Board
	if camera == null or board == null:
		push_error("MouseInputHandler: camera or grid_map not assigned")
	set_process_input(true)  # ensure this node receives _input events
	print(board)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_process_hover(event)
	elif event is InputEventMouseButton and event.pressed:
		_process_click(event)

	

func _process_hover(event: InputEventMouseMotion) -> void:
	var mouse_pos : Vector2 = event.position
	var result : Dictionary  = _cast_ray(mouse_pos)
	if result.size() == 0:
		return

	var collider : Node3D = result.collider
	var world_pos: Vector3 = result.position
	# Convert world position to map cell by using to_local() and local_to_map()
	var local_pos   : Vector3   = board.grid_map.to_local(world_pos)
	var cell        : Vector3i  = board.grid_map.local_to_map(local_pos)
	var tile  : Vector2i  = Vector2i(cell.x, cell.z)

	if collider is Piece:
		EventBus.emit_signal("piece_hovered", collider, tile)
	else:
		EventBus.emit_signal("tile_hovered", tile)

func _process_click(event: InputEventMouseButton) -> void:
	var mouse_pos : Vector2 = event.position
	var result : Dictionary  = _cast_ray(mouse_pos)
	if result.size() == 0:
		return

	var collider : Node3D = result.collider
	var world_pos: Vector3 = result.position
	# Convert world position to map cell by using to_local() and local_to_map()
	var local_pos   : Vector3   = board.grid_map.to_local(world_pos)
	var cell        : Vector3i  = board.grid_map.local_to_map(local_pos)
	var tile  : Vector2i  = Vector2i(cell.x, cell.z)

	if collider is Piece:
		EventBus.emit_signal("piece_clicked", collider, tile)
	else:
		EventBus.emit_signal("tile_clicked", tile)

func _cast_ray(screen_pos: Vector2) -> Dictionary:
	var from: Vector3 = camera.project_ray_origin(screen_pos)
	var to:   Vector3 = from + camera.project_ray_normal(screen_pos) * RAY_LENGTH
	var space: PhysicsDirectSpaceState3D = get_viewport().get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.new()
	query.from = from
	query.to   = to
	return space.intersect_ray(query)

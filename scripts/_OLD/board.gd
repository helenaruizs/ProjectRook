extends GridMap

var mouse : Vector2
const DIST := 1000.0

func _ready():
	var cells = get_used_cells()
	print(cells)


func _input(event: InputEvent) -> void:
	# Detect mouse hovering over a tile
	if event is InputEventMouseMotion:
		mouse = event.position
		get_mouse_world_pos(mouse)
	

func get_mouse_world_pos(mouse: Vector2):
	# Calculations to project a raycast from mouse position to the 3d tiles
	var space = get_world_3d().direct_space_state
	var start = get_viewport().get_camera_3d().project_ray_origin(mouse)
	var end = get_viewport().get_camera_3d().project_position(mouse, DIST)
	var params = PhysicsRayQueryParameters3D.new()
	params.from = start
	params.to = end
	
	var result = space.intersect_ray(params)
	
	return result

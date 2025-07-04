class_name DebugUtils

extends Object

var ray_length : float = Const.RAY_LENGTH
static func debug_key(event: InputEvent) -> bool:
	if event.is_action_pressed("debug_key"):
		return true
	else:
		return false
		
#static func debug_raycast(camera: Camera3D, screen_pos: Vector2) -> void:
	#if screen_pos == Vector2():
		#screen_pos = camera.get_viewport().get_mouse_position()
	#var hit = cast_ray(camera, screen_pos)
	#if hit.empty():
		#print_debug("[Debug] Ray at ", screen_pos, " hit nothing.")
	#else:
		#print_debug("[Debug] Ray at ", screen_pos, " →",
					#"\n    collider: ", hit.collider,
					#"\n    position: ", hit.position,
					#"\n    normal:   ", hit.normal)
#
#static func cast_ray(camera: Camera3D, screen_pos: Vector2) -> Dictionary:
	#var from = camera.project_ray_origin(screen_pos)
	#var to   = from + camera.project_ray_normal(screen_pos) * ray_length
	#var space = camera.get_world_3d().direct_space_state
	#var params = PhysicsRayQueryParameters3D.new()
	#params.from = from
	#params.to   = to
	#return space.intersect_ray(params)

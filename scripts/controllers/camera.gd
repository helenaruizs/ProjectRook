extends Camera3D

#@onready var raycast_3d = $RayCast3D
#const DIST := 1000.0
#var mouse_position : Vector2
#
#func _input(event):
	#if event is InputEventMouseMotion:
		#mouse_position = event.position
		#raycast_3d.target_position = project_local_ray_normal(mouse_position) * DIST
		#raycast_3d.force_raycast_update()
		#
		#print(raycast_3d.get_collider())
#
#func get_mouse_world_pos(mouse_position: Vector2):
	## Calculations to project a raycast from mouse position to the 3d tiles
	#var space = get_world_3d().direct_space_state
	#var start = get_viewport().get_camera_3d().project_ray_origin(mouse_position)
	#var end = get_viewport().get_camera_3d().project_position(mouse_position, DIST)
	#var params = PhysicsRayQueryParameters3D.new()
	#params.from = start
	#params.to = end
	#
	#var result = space.intersect_ray(params)
	#
	#return result

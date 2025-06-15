extends Node2D

#@export var tile_size : Vector2i = Vector2i(128, 64) # size of each board tile
#
#var astar_grid = AStarGrid2D.new() # Create a new pathfinding (AStar) instance
#var board_size : Vector2i = tile_size * tile_size
#
#func _ready():
	#initialize_astar_grid()
#
#func initialize_astar_grid():
	## Calculate the grid size based on the viewport size and cell size
	#astar_grid.size = board_size
	#astar_grid.cell_size = tile_size
	#astar_grid.offset = board_size/2 # Offset the grid cells for centering
	#astar_grid.update() # Apply the properties

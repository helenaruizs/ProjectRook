class_name MovementData

extends Resource

@export var style : Enums.MoveStyle
@export var pattern : Enums.MovePattern
@export var length : Enums.MoveLength
@export var shape_resource: MovementShapeResource = null
@export var first_move_shape: MovementShapeResource = null

func get_shape_vectors() -> Array[Vector2i]:
	if shape_resource:
		return shape_resource.get_vectors()
	return []

@tool
class_name MovementShapeResource

extends Resource

@export var name: String = "Untitled Shape"
@export var steps: Array[Enums.Direction] =[]

#### HELPERS ####
func get_vectors() -> Array[Vector2i]:
	var origin: Vector2i = Vector2i(0,0)
	var vectors: Array[Vector2i] =[]
	var dir_vector: Vector2i
	for dir: Enums.Direction in steps:
		dir_vector = Enums.dir_to_vector(dir)
	for step in range(1, steps.size()):
		var pos: Vector2i = origin + dir_vector * step
		vectors.append(pos)
	return vectors

@tool
class_name MovementShapeResource

extends Resource

@export var name: String = "Untitled Shape"
@export var steps: Array[Enums.Direction] =[]

#### HELPERS ####
func get_vectors() -> Array[Vector2i]:
	var vectors: Array[Vector2i] =[]
	for dir: Enums.Direction in steps:
		vectors.append(Enums.dir_to_vector(dir))
	return vectors

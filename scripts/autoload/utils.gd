extends Node

# A single RNG you can seed or randomize once
var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	# For unpredictable games, randomize on start:
	rng.randomize()
	# Or for reproducible testing, use a fixed seed:
	# rng.seed = 12345


# Helper methods
func randf() -> float:
	return rng.randf()

func randi_range(min: int, max: int) -> int:
	return rng.randi_range(min, max)

func clamp_int(value: int, min: int, max: int) -> int:
	return clamp(value, min, max)

func flatten_dict_of_arrays(dict: Dictionary) -> Array:
	var result: Array = []
	for arr: Array in dict.values():
		result.append_array(arr)
	return result

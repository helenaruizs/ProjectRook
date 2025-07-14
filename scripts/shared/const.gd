class_name Const

extends Node

const RAY_LENGTH: float = 1000.0

# 2D directions for grid scans
const DIRS := {
	"up": Vector2i(0, 1),
	"down": Vector2i(0, -1),
	"left": Vector2i(-1, 0),
	"right": Vector2i(1, 0),
	"up_left": Vector2i(-1, 1),
	"up_right": Vector2i(1, 1),
	"down_left": Vector2i(-1, -1),
	"down_right": Vector2i(1, -1),
}

# Movement "shapes"
const L_SHAPE = [DIRS["up"], DIRS["up"], DIRS["right"]] # forward, forward, side

const KNIGHT_OFFSETS: Array[Vector2i] = [
	Vector2i(1, 2), Vector2i(2, 1), Vector2i(-1, 2), Vector2i(-2, 1),
	Vector2i(1, -2), Vector2i(2, -1), Vector2i(-1, -2), Vector2i(-2, -1)
]

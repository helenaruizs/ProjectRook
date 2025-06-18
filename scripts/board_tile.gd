@tool  # FIXME This is only for previewing the board materials in the editor

class_name BoardTile

extends Node3D

signal tile_hovered(x, y)

enum TileType {
	BLACK,
	WHITE,
}

enum Files {
	A,
	B,
	C,
	D,
	E,
	F,
	G,
	H,
}

enum Ranks {
	_1,
	_2,
	_3,
	_4,
	_5,
	_6,
	_7,
	_8,
}

# HACK: Hardcoded these materials
const BOARD_TILE_BLACK = preload("res://assets/materials/board_tile_black.tres")
const BOARD_TILE_WHITE = preload("res://assets/materials/board_tile_white.tres")

@export_subgroup("Tile Instance Properties")
@export var tile_type : TileType:
	set(new_type):
		tile_type = new_type
		
@export var file : Files # Files are the columns, from left to right, from A-H
@export var rank : Ranks # Ranks are the rows, they go from bottom to top, from 1-8

@export_subgroup("Children Setup")
@export var mesh : MeshInstance3D
@export var static_body : StaticBody3D

var tile_pos := Vector3(0, 0, 0)

func _ready():
	update_mesh_per_tile_type()
	tile_pos = global_transform.origin


# HACK: Cheapest solution for this, pretty non scaleable
func update_mesh_per_tile_type():
	match tile_type:
		TileType.BLACK:
			mesh.material_override = BOARD_TILE_BLACK
		TileType.WHITE:
			mesh.material_override = BOARD_TILE_WHITE
		_:
			null


func _mouse_hover_entered():
	var array =[file, rank]
	print(array)

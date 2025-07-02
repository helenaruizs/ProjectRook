class_name VisualsComponent

extends Node3D

var skin : SkinResource

@onready var sprite: Sprite3D = $Sprite3D
@onready var hover_area: Area3D = $Area3D


func _ready() -> void:
	hover_area.input_ray_pickable = true
	hover_area.mouse_entered.connect(_on_hover_enter)
	hover_area.mouse_exited.connect(_on_hover_exit)
	
	
func set_texture(tex: Texture2D) -> void:
	sprite.texture = tex


func _on_hover_enter() -> void:
	# Tell the game which piece is hovered. We assume the parent is the Piece node.
	var piece := get_parent() as Piece
	EventBus.emit_signal("piece_hovered", piece, piece.board_pos)

func _on_hover_exit() -> void:
	# Tell the game which piece is hovered. We assume the parent is the Piece node.
	var piece := get_parent() as Piece
	EventBus.emit_signal("piece_hover_end", piece, piece.board_pos)

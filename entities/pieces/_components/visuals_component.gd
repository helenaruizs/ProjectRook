class_name VisualsComponent

extends Node3D

var skin : SkinResource
@onready var sprite: Sprite3D = $Sprite3D

func set_texture(tex: Texture2D) -> void:
	sprite.texture = tex

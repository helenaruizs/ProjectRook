class_name VisualsComponent

extends Node3D

@onready var sprite: Sprite3D = $Sprite3D
@onready var area3d: Area3D = $Area3D

var texture: Texture2D

func get_texture_from_data(skin: SkinResource.SkinNames, color: Enums.FactionColor, piece_type: Enums.PieceType) -> void:
	if skin != null:
		texture = SkinManager.get_texture(skin, color, piece_type)
		sprite.texture = texture

func on_state_changed(new_state: Enums.States) -> void:
	match new_state:
		Enums.States.HIGHLIGHTED:
			sprite.modulate = Color(1,1,0)   # yellow
		Enums.States.SELECTED:
			sprite.modulate = Color(0,1,0)   # green
		Enums.States.IDLE:
			sprite.modulate = Color(1,1,1)   # green
		_:
			sprite.modulate = Color(1,1,1)   # normal

#func set_texture(tex: Texture2D) -> void:
	#sprite.texture = tex
#
##region Area 3D mouse event functions
#
#func _on_hover_enter() -> void:
	#piece.is_hovered = true
	#emit_signal("condition_emitted", Enums.Conditions.HOVER_ENTER)
#
#func _on_hover_exit() -> void:
	#piece.is_hovered = false
	#emit_signal("condition_emitted", Enums.Conditions.HOVER_EXIT)
#
##endregion
#
#
#func on_state_changed(new_state: Enums.States) -> void:
	#match new_state:
		#Enums.States.HIGHLIGHTED:
			#sprite.modulate = Color(1,1,0)   # yellow
		#Enums.States.SELECTED:
			#sprite.modulate = Color(0,1,0)   # green
		#Enums.States.IDLE:
			#sprite.modulate = Color(1,1,1)   # green
		#_:
			#sprite.modulate = Color(1,1,1)   # normal

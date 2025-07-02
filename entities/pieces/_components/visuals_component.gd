class_name VisualsComponent

extends Node3D

signal condition_emitted(cond: int)

var skin : SkinResource

@onready var sprite: Sprite3D = $Sprite3D
@onready var area3d: Area3D = $Area3D


func _ready() -> void:
	area3d.input_ray_pickable = true
	area3d.mouse_entered.connect(_on_hover_enter)
	area3d.mouse_exited .connect(_on_hover_exit)
	
	
func set_texture(tex: Texture2D) -> void:
	sprite.texture = tex


func _on_hover_enter() -> void:
	emit_signal("condition_emitted", Enums.Conditions.HOVER_ENTER)

func _on_hover_exit() -> void:
	emit_signal("condition_emitted", Enums.Conditions.HOVER_EXIT)


func _on_area_3d_mouse_entered() -> void:
	pass # Replace with function body.

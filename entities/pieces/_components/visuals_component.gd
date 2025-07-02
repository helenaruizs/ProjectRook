class_name VisualsComponent

extends Node3D

signal condition_emitted(cond: Enums.Conditions)

var skin : SkinResource

@onready var sprite: Sprite3D = $Sprite3D
@onready var area3d: Area3D = $Area3D


func _ready() -> void:
	var piece := get_parent() as Piece
	var state_machine  := piece.state_machine
	#state_machine.connect("state_changed", Callable(self, "_on_state_changed"))
	area3d.input_ray_pickable = true
	area3d.mouse_entered.connect(_on_hover_enter)
	area3d.mouse_exited .connect(_on_hover_exit)
	
	
func set_texture(tex: Texture2D) -> void:
	sprite.texture = tex

#region Area 3D mouse event functions

func _on_hover_enter() -> void:
	emit_signal("condition_emitted", Enums.Conditions.HOVER_ENTER)

func _on_hover_exit() -> void:
	emit_signal("condition_emitted", Enums.Conditions.HOVER_EXIT)

#endregion


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

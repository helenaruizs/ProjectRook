class_name TileMarker

extends Node3D

#signal marker_hovered(tile_marker: TileMarker, piece: Piece )
#signal marker_hovered_out(tile_marker: TileMarker, piece: Piece)
#signal marker_selected()
@onready var debug_label: Label3D = $Label3D # TEST: Marker coord label for dubugging

@onready var area3d: Area3D = $Area3D

@export_category("Tile Conditions")

# NOTE: This is something called bit flags, and it's kinda like a bar code situation, it makes it so each entry is an on/off switch
enum Conditions {
	NONE = 0,           # 0000
	OCCUPIED = 1 << 0,  # 0001 = 1
	ACTIVE = 1 << 1,    # 0010 = 2
	TARGET = 1 << 2,    # 0100 = 4
	PATH = 1 << 3,      # 1000 = 8 (...)
	
	HAS_ACTIVE_PIECE = 1 << 4,
	HAS_ENEMY = 1 << 5,
	HAS_FRIEND = 1 << 6,
	HAS_KING = 1 << 7,
	
	HAS_OBJECTIVE = 1 << 8,
	HAS_ITEM = 1 << 9,
	
	LOCKED = 1 << 10,
	BROKEN = 1 << 11,
	HAZARD = 1 << 12, # could be explosive, a trap, a debuff, etc...
	
	IS_HOVERED = 1 << 13,
	IS_SELECTED = 1 << 14,
	
	ATTACK_TARGET = 1 << 15,
}

@export_flags(
	# None -> It equals 0, so needs to be ommitted
	"Occupied",
	"Active",
	"Target",
	"Path",
	
	"Has Active Piece",
	"Has Enemy",
	"Has Friend",
	"Has King",
	
	"Has Objective",
	"Has Item",
	
	"Locked",
	"Broken",
	"Hazard",
	
	"Is Hovered",
	"Is Selected",
	
	"Attack Target")
	
var conditions_mask : int = Conditions.NONE # Variable name of the "box" for the flags above ^

# Maps a conditions‐mask → a tile‐state
# Each rule can be either an exact match or a “contains these bits” match.
const CONDITION_STATE_RULES: Array[Dictionary] = [
# 1) Exact free‐tile → AVAILABLE
	{
		"mask": Conditions.NONE,
		"match_exact": true,
		"state": Enums.TileStates.NORMAL,
	},
# 2) Enemy on a target square (exact match)
	{
		"mask": Conditions.OCCUPIED | Conditions.HAS_ENEMY | Conditions.TARGET,
		"match_exact": true,
		"state": Enums.TileStates.ATTACK_TARGET,
	},

# 3) Any occupied enemy tile
	{
		"mask": Conditions.OCCUPIED | Conditions.HAS_ENEMY,
		"match_exact": false,
		"state": Enums.TileStates.HAS_ENEMY,
	},

# 4) Any occupied friendly tile
	{
		"mask": Conditions.OCCUPIED | Conditions.HAS_FRIEND,
		"match_exact": false,
		"state": Enums.TileStates.HAS_FRIEND,
	},

# 5) Any move path
	{
		"mask": Conditions.PATH,
		"match_exact": false,
		"state": Enums.TileStates.MOVE_PATH,
	},

# 6) Any move target
	{
		"mask": Conditions.TARGET,
		"match_exact": false,
		"state": Enums.TileStates.MOVE_TARGET,
	},

# 7) The active piece’s own tile
	{
		"mask": Conditions.HAS_ACTIVE_PIECE,
		"match_exact": false,
		"state": Enums.TileStates.HAS_ACTIVE_PIECE,
	},

# 8) Any special “king in check” tile
	{
		"mask": Conditions.OCCUPIED | Conditions.HAS_ENEMY | Conditions.HAS_KING,
		"match_exact": true,
		"state": Enums.TileStates.HAS_ENEMY_KING,
	},

	# …add more specific rules here…
]

const DEFAULT_TILE_STATE := Enums.TileStates.NORMAL

var state:= DEFAULT_TILE_STATE

var occupant: Piece = null   # ← who sits on this tile, if any

# Scene References
# NOTE: Gotta make sure these don't change names
@onready var mesh: MeshInstance3D = $MarkerMesh
@onready var hover_overlay: MeshInstance3D = $HoverOverlay
@onready var select_overlay: MeshInstance3D = $SelectOverlay



@export_category("Materials")
@export var mat_normal: Material
@export var mat_available: Material
@export var mat_blocked: Material
@export var mat_has_active_piece: Material
@export var mat_move_path: Material
@export var mat_move_target: Material
@export var mat_has_enemy: Material
@export var mat_has_player: Material
@export var mat_has_objective: Material
@export var mat_has_enemy_king: Material
@export var mat_has_player_king: Material
@export var mat_attack_target: Material

# FIXME: This state to material is overkill, leaving it for now for testing
# Build a lookup once
@onready var _materials: Dictionary = {
	Enums.TileStates.NORMAL: mat_normal,
	Enums.TileStates.AVAILABLE: mat_available,
	Enums.TileStates.BLOCKED: mat_blocked,
	Enums.TileStates.HAS_ACTIVE_PIECE: mat_has_active_piece,
	Enums.TileStates.MOVE_PATH: mat_move_path,
	Enums.TileStates.MOVE_TARGET: mat_move_target,
	Enums.TileStates.HAS_ENEMY: mat_has_enemy,
	Enums.TileStates.HAS_FRIEND: mat_has_player,
	Enums.TileStates.OBJECTIVE: mat_has_objective,
	Enums.TileStates.HAS_ENEMY_KING: mat_has_enemy_king,
	Enums.TileStates.HAS_PLAYER_KING: mat_has_player_king,
	Enums.TileStates.ATTACK_TARGET: mat_attack_target,
}

var board : Board

func _ready() -> void:
	board = get_parent()
	area3d.input_ray_pickable = true
	area3d.mouse_entered.connect(_on_hover_enter)
	area3d.mouse_exited.connect(_on_hover_exit)
	area3d.input_event.connect(_on_marker_input_event)
	_check_state_and_apply()
	
	
# Condition Helpers


func add_condition(cond: int) -> void:
	conditions_mask |= cond

func remove_condition(cond: int) -> void:
	conditions_mask &= ~cond

func has_condition(cond: int) -> bool:
	return (conditions_mask & cond) != 0

func _check_state_and_apply() -> void:
	var new_state: Enums.TileStates = _resolve_state_from_conditions(conditions_mask)
	if new_state != state:
		_change_state(new_state)
	#_update_overlays()

func _resolve_state_from_conditions(cond_mask: int) -> Enums.TileStates:
	for rule in CONDITION_STATE_RULES:
		var mask: int = rule["mask"]
		if rule["match_exact"] and cond_mask == mask:
			return rule["state"] as Enums.TileStates
		elif (not rule["match_exact"]) and (cond_mask & mask) == mask:
			return rule["state"] as Enums.TileStates
	return DEFAULT_TILE_STATE

func _change_state(new_state: Enums.TileStates) -> void:
	state = new_state
	_trigger_state(new_state)
	# you could also emit a signal here if other systems care
	# emit_signal("state_changed", state)
	
func _trigger_state(state: Enums.TileStates) -> void:
	# Base mesh
	if state == Enums.TileStates.NORMAL:
		mesh.hide()
	else:
		mesh.show()
		mesh.material_override = _materials.get(state, mat_normal)
		#

#### PUBLIC ######
func register_occupant(new_piece: Piece) -> void:
	if new_piece == occupant:
		return
	
	occupant = new_piece
	
	remove_condition(
		Conditions.OCCUPIED |
		Conditions.HAS_FRIEND |
		Conditions.HAS_ENEMY |
		Conditions.HAS_KING
	)
	
	if new_piece != null:
		add_condition(Conditions.OCCUPIED)
		if new_piece.alliance == Enums.Alliance.FRIEND:
			add_condition(Conditions.HAS_FRIEND)
		if new_piece.alliance == Enums.Alliance.FOE:
			add_condition(Conditions.HAS_ENEMY)
		if new_piece.type == Enums.PieceType.KING:
			add_condition(Conditions.HAS_KING)
	
	_check_state_and_apply()

#### SIGNALS #####

func _on_hover_enter() -> void:
	hover_overlay.show()
	if occupant and occupant.player_controlled:
		occupant.handle_tile_input(Enums.InteractionType.HOVER_IN, self)
		occupant.get_moves()
	SignalBus.emit_signal("marker_hovered", self)

func _on_hover_exit() -> void:
	hover_overlay.hide()
	if occupant and occupant.player_controlled:
		occupant.handle_tile_input(Enums.InteractionType.HOVER_OUT, self)
	SignalBus.emit_signal("marker_hovered_out", self)

# this method signature matches the engine's signal:
func _on_marker_input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if occupant and occupant.player_controlled:
			occupant.handle_tile_input(Enums.InteractionType.SELECT, self)
		SignalBus.emit_signal("marker_selected", self)


#### DEBUG #####
# TEST: Tile Marker Debug label function 
func set_debug_label(text: String, show: bool = true) -> void:
	debug_label.text = text
	debug_label.visible = show

class_name Piece

extends Node3D

@export var config: PieceResource

@export_subgroup("Basic Nodes Setup")
@export var visuals : VisualsComponent
@export var movement : MovementComponent
@export var stats : StatsComponent
@export var modifiers : ModifiersComponent
@export var state_machine : StateMachine

var skin: SkinResource.SkinNames
var color : Enums.FactionColor
var type: Enums.PieceType:
	get:
		return config.piece_data.type

var board_pos: Vector2i
var alliance: Enums.Alliance

var hovered: bool = false
var selected: bool = false

var player_controlled: bool = false


# Status tracking variables
var moves_cache:= {}
var moves_dirty: bool = true
var has_moved: bool = false # used for the pawns

var player_root: PlayerRoot


func set_config(_config: PieceResource) -> void:
	config = _config

func initial_setup(_player_root: PlayerRoot, player_color: Enums.FactionColor, player_skin: SkinResource.SkinNames, player_alliance: Enums.Alliance, _board: Board) -> void:
	set_player_colors(player_color, player_skin)
	set_team(player_alliance)
	set_movement_component(_board)
	initialize_visuals()
	player_root = _player_root
	
func set_player_colors(player_color: Enums.FactionColor, player_skin: SkinResource.SkinNames) -> void:
	color = player_color
	skin = player_skin

func set_team(player_alliance: Enums.Alliance) -> void:
	alliance = player_alliance

func set_movement_component(_board: Board) -> void:
	movement.get_board(_board)
	movement.get_move_data(config.movement_data)

func initialize_visuals() -> void:
	visuals.get_texture_from_data(skin, color, type)

func update_visuals(state: Enums.States) -> void:
	visuals.on_state_changed(state)

func move_piece_to_marker(marker: TileMarker) -> void:
	self.position = marker.position

func move_piece_to_coord(board: Board, coord: Vector2i) -> void:
	self.position = board.get_world_position(coord.x, coord.y)

func handle_tile_input(event_type: Enums.InteractionType, tile: TileMarker) -> void:
	state_machine.handle_interaction_fsm(event_type)
	SignalBus.emit_signal("piece_input", event_type, self)

func set_hovered(answer: bool) -> void:
	hovered = answer
	
func is_hovered() -> bool:
	return hovered

func set_selected(answer: bool) -> void:
	selected = answer

func is_selected() -> bool:
	return selected

func desselect() -> void:
	selected = false
	state_machine.handle_interaction_fsm(Enums.InteractionType.DESELECT)

func set_player_controlled(answer: bool) -> void:
	player_controlled = answer

func is_friend(reference_alliance: Enums.Alliance) -> bool:
	return alliance == reference_alliance

func get_forward_dir() -> Vector2i:
	return player_root.get_forward_dir()

func get_moves() -> Dictionary:
	if moves_dirty:
		moves_cache = movement.get_all_moves(board_pos)
		moves_dirty = false
	return moves_cache


#signal piece_hovered(piece: Piece, board_pos: Vector2i, moves: Dictionary)
#signal piece_hovered_exit()
#signal piece_selected(piece: Piece, board_pos: Vector2i, moves: Dictionary)
#signal piece_selected_exit(piece: Piece, board_pos: Vector2i, moves: Dictionary)
#
#@export var piece_type : Enums.PieceType
#
#@export_subgroup("Basic Nodes Setup")
#@export var visuals : VisualsComponent
#@export var movement : MovementComponent
#@export var stats : StatsComponent
#@export var modifiers : ModifiersComponent
#@export var state_machine : StateMachine
#
#
#@export_subgroup("Movement Properties")
#@export var move_style : Enums.MoveStyle
#@export var move_pattern : Enums.MovePattern
#@export var move_length : Enums.MoveLength
#
#var piece_color : Enums.FactionColor
#var board_pos : Vector2i
#
#var moves: Dictionary = {}
#var has_moved: bool = false
#var is_hovered: bool = false
#var is_selected: bool = false
#var board : Board
#
## NOTE: Signal subscriptions are being derrived from the Game Manager, for differentiation between player and opponent pieces
#
#func update_visuals(tex : Texture2D) -> void:
	#visuals.set_texture(tex)
#
#func update_position(world_pos: Vector3) -> void:
	#if movement != null:
		#movement.move_to_position(world_pos)
#
#func _on_condition(cond: Enums.Conditions) -> void:
	## forward the semantic event to your FSM
	#state_machine.on_condition(cond)
#
#func _on_state_changed(piece: Piece, new_state: Enums.States) -> void:
	#visuals.on_state_changed(new_state)
#
#func _on_piece_hover(tile_marker: TileMarker, piece: Piece) -> void :
	#if not state_machine.is_current_state(Enums.States.SELECTED):
		#state_machine.change_state(Enums.States.HIGHLIGHTED)
	#
#func _on_piece_hover_out(tile_marker: TileMarker, piece: Piece) -> void :
	#if state_machine.is_current_state(Enums.States.HIGHLIGHTED):
		#state_machine.change_state(Enums.States.IDLE)
#
#func _on_piece_selected() -> void :
	#print("This is from the Piece")
	#state_machine.change_state(Enums.States.SELECTED)
#
#func _on_piece_selected_out() -> void :
	#state_machine.change_state(Enums.States.IDLE)

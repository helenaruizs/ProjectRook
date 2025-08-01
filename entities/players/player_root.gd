class_name PlayerRoot

extends Node

var player_config: PlayerConfig
var player_color: Enums.FactionColor
var player_skin: SkinResource.SkinNames
var player_type: Enums.PlayerType:
	get:
		return player_config.player_type

var current_selected_piece : Piece = null

@export var pieces_container: Node3D

func _ready() -> void:
	await owner	
	if player_config:
		player_color = player_config.faction
		player_skin = player_config.skin
	
	SignalBus.piece_select.connect(self.set_selected_piece)
	
### PUBLIC ####

func setup(_player_config: PlayerConfig) -> void:
	player_config = _player_config
	player_color = player_config.faction
	player_skin = player_config.skin

func get_player_color() -> Enums.FactionColor:
	return player_color
	
func get_player_skin() -> SkinResource.SkinNames:
	return player_skin

func get_player_alliance() -> Enums.Alliance:
	return player_config.alliance

func get_pieces_container() -> Node3D:
	return pieces_container

func clear_pieces() -> void:
	var placed_pieces: Array[Node] = get_tree().get_nodes_in_group("pieces")
	for piece_node in placed_pieces:
		if piece_node is Node:
			piece_node.queue_free()
			
func set_selected_piece(piece: Piece) -> void:
	if current_selected_piece != piece:
		if current_selected_piece:
			#SignalBus.emit_signal("piece_deselect", current_selected_piece)
			current_selected_piece.desselect()
		current_selected_piece = piece

func get_forward_dir() -> Vector2i:
	match player_config.board_placement:
		Enums.BoardPlacement.FRONT:
			return Vector2i(0, 1)   # "up"
		Enums.BoardPlacement.BACK:
			return Vector2i(0, -1)  # "down"
		_:
			return Vector2i(0, 1)   # default/fallback (up)

class_name PlayerRoot

extends Node

var player_config: PlayerConfig
var player_color: Enums.FactionColor
var player_skin: SkinResource.SkinNames

@export var pieces_container: Node3D

func _ready() -> void:
	await owner
	if player_config:
		player_color = player_config.faction
		player_skin = player_config.skin
	
	
### PUBLIC ####

func setup(_player_config: PlayerConfig) -> void:
	player_config = _player_config
	player_color = player_config.faction
	player_skin = player_config.skin

func get_player_color() -> Enums.FactionColor:
	return player_color
	
func get_player_skin() -> SkinResource.SkinNames:
	return player_skin

func get_pieces_container() -> Node3D:
	return pieces_container

func clear_pieces() -> void:
	var placed_pieces: Array[Node] = get_tree().get_nodes_in_group("pieces")
	for piece_node in placed_pieces:
		if piece_node is Node:
			piece_node.queue_free()

class_name PiecesRoot

extends Node3D

var player_config: PlayerConfig


func clear_pieces() -> void:
	var placed_pieces: Array[Node] = get_tree().get_nodes_in_group("pieces")
	for piece_node in placed_pieces:
		if piece_node is Node:
			piece_node.queue_free()

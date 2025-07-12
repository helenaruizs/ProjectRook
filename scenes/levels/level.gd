class_name Level

extends Node3D

@export var level_data: LevelResource 

@export_category("Nodes Setup")
@export var board: Board
@export var players: Players
@export var piece_spawner: PieceSpawner

func _ready() -> void:
	setup_child_nodes(board, players, piece_spawner)
	board.scan_tiles()
	board.spawn_markers()
	players.boot_players()
	

func setup_child_nodes(_board: Board, _players: Players, _piece_spawner: PieceSpawner) -> void:
	piece_spawner.setup(_board, _players)
	board.setup(_players, _piece_spawner)
	players.setup(_board, _piece_spawner)

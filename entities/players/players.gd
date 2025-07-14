class_name Players

extends Node

@export var player_configs: Array[PlayerConfig]
var piece_spawner: PieceSpawner

var board: Board
var player_root_scn: PackedScene
var player_root_nodes: Array[PlayerRoot] = []

func _ready() -> void:
	await owner
	
	player_root_scn = Refs.player_scn

##### PUBLIC ######
func setup(_board: Board, _piece_spawner: PieceSpawner) -> void:
	board = _board
	piece_spawner = _piece_spawner

func setup_starting_pieces(_player_node: PlayerRoot, _player_config: PlayerConfig) -> void:
	# "Read" the player config for the 
	var row_ranks: Dictionary = board.get_player_row_ranks(_player_config.board_placement)
	var back_row_rank: int = row_ranks["back"]
	var front_row_rank: int = row_ranks["front"]
	
	spawn_row(_player_config.back_row, back_row_rank, _player_node, board, piece_spawner)
	spawn_row(_player_config.front_row, front_row_rank, _player_node, board, piece_spawner)
		
func spawn_row(
	row: Array[PieceResource],
	rank: int,
	player_node: PlayerRoot,
	board: Board,
	piece_spawner: PieceSpawner
) -> void:
	for file in row.size():
		var piece_res: PieceResource = row[file]
		var piece_inst: Piece = piece_spawner.create_piece_instance(piece_res)
		piece_inst.board_pos = Vector2i(file, rank)
		piece_inst.move_piece_to_coord(board, piece_inst.board_pos)
		add_child_piece(piece_inst, player_node)
		var spawn_marker: TileMarker = board.get_marker(piece_inst.board_pos)
		spawn_marker.register_occupant(piece_inst)

func add_child_piece(piece_instance: Piece, _player_node: PlayerRoot) -> void:
	var spawn_root: PlayerRoot = _player_node
	var pieces_container: Node3D = spawn_root.get_pieces_container()
	pieces_container.add_child(piece_instance)
	var color: Enums.FactionColor = spawn_root.get_player_color()
	var skin: SkinResource.SkinNames = spawn_root.get_player_skin()
	var alliance: Enums.Alliance = spawn_root.get_player_alliance()
	piece_instance.initial_setup(spawn_root, color, skin, alliance, board, )
	if _player_node.player_type == Enums.PlayerType.HUMAN:
		piece_instance.set_player_controlled(true)


func get_players() -> Array[PlayerRoot]:
	return player_root_nodes

##### PRIVATE #####
func boot_players() -> void:
	for player_config: PlayerConfig in player_configs:
		var player_node: PlayerRoot  = player_root_scn.instantiate()
		self.add_child(player_node)
		player_node.setup(player_config)
		player_root_nodes.append(player_node)
		setup_starting_pieces(player_node, player_config)
	
	board.register_teams(player_configs)

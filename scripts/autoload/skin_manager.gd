extends Node

# drop any new .tres into this folder and it just works.
@export_dir var skin_dir: String = "res://resources/skins/"

@export var bishop : PackedScene
@export var king : PackedScene
@export var knight : PackedScene
@export var pawn : PackedScene
@export var queen : PackedScene
@export var rook : PackedScene

var pieces : Dictionary[Enums.PieceType, PackedScene] = {
	Enums.PieceType.BISHOP : bishop,
	Enums.PieceType.KING : king,
	Enums.PieceType.KNIGHT : knight,
	Enums.PieceType.PAWN : pawn,
	Enums.PieceType.QUEEN : queen,
	Enums.PieceType.ROOK : rook,
}

# Internal lookup: (SkinNames, FactionColor) → SkinResource
var skins: Dictionary[Vector2, SkinResource] = {}

func _ready() -> void:
	_load_all_skins()
	
func _load_all_skins() -> void:
	skins.clear()  # start fresh
	var dir: DirAccess = DirAccess.open(skin_dir)
	if dir == null:
		push_error("Could not open skins directory: %s" % skin_dir)
		return

	dir.list_dir_begin()
	var filename: String = dir.get_next()
	# Loop until get_next() returns the empty string
	var safety_counter:= 0 # Safety killswitch for the loop
	while filename != "" and safety_counter < 1_000:
		# Only consider files ending in “.tres”
		if filename.ends_with(".tres"):
			var path: String = "%s/%s" % [skin_dir, filename]
			var loaded := load(path)
			var skin_res: SkinResource = loaded as SkinResource
			# Only store it if it really is a SkinResource
			if skin_res != null:
				var key: Vector2 = Vector2(skin_res.id, skin_res.faction_color)
				skins[key] = skin_res
		filename = dir.get_next()
		safety_counter += 1
	if safety_counter >= 1000:
		push_error("Skin loading loop exceeded limit; aborting to avoid lockup.")

	dir.list_dir_end()


func get_skin(
	id:   SkinResource.SkinNames,
	color: Enums.FactionColor
) -> SkinResource:
	var key: Vector2 = Vector2(id, color)
	var result: SkinResource = skins.get(key, null) # null here is just the default result in case there's no result, to avoid breaking error
	return result


func get_texture(
	id:    SkinResource.SkinNames,
	color: Enums.FactionColor,
	piece_type:    Enums.PieceType
) -> Texture2D:
	var skin_res: SkinResource = get_skin(id, color)
	# If we found a SkinResource, return its texture for this piece
	if skin_res != null:
		return skin_res.get_texture_for(piece_type)
	# Otherwise, no texture available
	return null


func get_piece(piece: Enums.PieceType) -> PackedScene :
	var key: int = piece
	return pieces.get(key, null)

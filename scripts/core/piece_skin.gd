class_name PieceSkin

extends Resource

@export var id             : String      # e.g. "Classic/Knight"
@export var piece_type     : int         # use your PieceType enum
@export var scene          : PackedScene # e.g. the .tscn for this piece
@export var material       : Material    # an optional material override
# …any other data you need (textures, animations, offsets…)

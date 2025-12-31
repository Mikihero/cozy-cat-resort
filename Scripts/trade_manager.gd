extends Node

var items_array = ["wood", "clay", "stone"]

@export var clay_texture: Texture2D
@export var wood_texture: Texture2D
@export var stone_texture: Texture2D

@onready var item_textures_dict = {
	"wood": wood_texture,
	"clay": clay_texture,
	"stone": stone_texture,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	items_array.shuffle()
	
	print(item_textures_dict)
	print(clay_texture)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func receive_trade_item() -> Variant:
	return items_array.pop_front()

extends Node

var items_array = ["wood", "clay", "stone"]

@export var clay_texture: Texture2D
@export var wood_texture: Texture2D
@export var stone_texture: Texture2D

var item_textures_dict: Dictionary

# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	items_array.shuffle()
	item_textures_dict = {
	"wood": wood_texture,
	"clay": clay_texture,
	"stone": stone_texture,
	}
	
	print(item_textures_dict)
	print(clay_texture)
	print(items_array)

func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func receive_trade_item() -> Variant:
	return items_array.pop_front()

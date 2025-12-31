extends Node

var items_array = ["wood", "clay", "stone"]
var item_textures_dict: Dictionary

# base prices per unit set here, randomized by +-25% on each load
var item_prices_dict = {
	"wood": 10,
	"clay": 10,
	"stone": 10,
}

var item_amounts_dict = {
	"wood": 25,
	"clay": 25,
	"stone": 25,
}

@export var clay_texture: Texture2D
@export var wood_texture: Texture2D
@export var stone_texture: Texture2D


# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	items_array.shuffle()
	
	item_textures_dict = {
		"wood": wood_texture,
		"clay": clay_texture,
		"stone": stone_texture,
	}
	
	for item in items_array:
		var value = item_prices_dict[item]
		value = floor(value * randf_range(0.5, 1.5))
		item_prices_dict[item] = value
		
	for item in items_array:
		var amount = item_amounts_dict[item]
		amount = floor(amount * randf_range(0.5, 1.5))
		item_amounts_dict[item] = amount
		
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func receive_trade_item() -> Variant:
	return items_array.pop_front()
	
func receive_item_amount(item: String) -> int:
	return item_amounts_dict[item]
	
func receive_item_price(item: String) -> int:
	return item_prices_dict[item]

extends HBoxContainer

var image: Texture2D
var resource_name: String

@onready var item_texture: TextureRect = $CenterContainer/item_texture;
@onready var item_count: Label = $CenterContainer4/item_count;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if image:
		item_texture.texture = image
	item_count.text = str(Globals.inventory[resource_name])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	item_count.text = str(Globals.inventory[resource_name])

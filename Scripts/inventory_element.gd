extends HBoxContainer

var image :Texture2D
var resource_name: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if image:
		$CenterContainer/item_texture.texture = image
	$CenterContainer4/item_count.text = Globals.inventory[resource_name]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$CenterContainer4/item_count.text = Globals.inventory[resource_name]

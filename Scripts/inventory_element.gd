extends HBoxContainer

var image :Texture2D
var amount :int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if image:
		$CenterContainer/item_texture.texture = image
	$CenterContainer4/item_count.text = str(amount)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

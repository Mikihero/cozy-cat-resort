extends Sprite2D

func _ready() -> void:
	var target_size = Vector2(384, 216)
	var texture_size = $Background.texture.get_size()
	scale = target_size / texture_size

extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var gacha = preload("res://Scenes/gacha.tscn")
func _button_pressed() -> void:
	get_tree().change_scene_to_packed(gacha)

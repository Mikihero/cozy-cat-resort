extends Button


var game = preload("res://Scenes/main_scene.tscn")

func _ready() -> void:
	pressed.connect(_button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _button_pressed() -> void:
	get_tree().change_scene_to_packed(game)

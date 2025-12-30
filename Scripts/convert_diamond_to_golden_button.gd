extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_button_pressed)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _button_pressed() -> void:
	if Globals.DiamondCatCoins - 1 < 0:
		Globals.DiamondCatCoins -= 1
		Globals.GoldCatCoins += 10
	pass

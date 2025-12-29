extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _button_pressed() -> void:
	Globals.CatCoins += 100
	Globals.GoldCatCoins += 10
	Globals.DiamondCatCoins += 1

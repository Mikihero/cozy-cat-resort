extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_coins()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_coins()

func update_coins() -> void:
	$"MarginContainer/MarginContainer/HBoxContainer/Coin status/CatCoinsText".text = str(Globals.CatCoins)
	$"MarginContainer/MarginContainer/HBoxContainer/Coin status2/GoldCatCoinsText".text = str(Globals.GoldCatCoins)
	$"MarginContainer/MarginContainer/HBoxContainer/Coin status3/DiamondCatCoinsText".text = str(Globals.DiamondCatCoins)

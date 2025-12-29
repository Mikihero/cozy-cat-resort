extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_coins()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_coins() -> void:
	$"HBoxContainer/Coin status/CatCoinsText".text = str(Globals.CatCoins)
	$"HBoxContainer/Coin status2/GoldCatCoinsText".text = str(Globals.GoldCatCoins)
	$"HBoxContainer/Coin status3/DiamondCatCoinsText".text = str(Globals.DiamondCatCoins)

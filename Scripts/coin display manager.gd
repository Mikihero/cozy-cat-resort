extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_updateCoins()
	pass
	
func _updateCoins() -> void:
	$"silver coin amount".text = str(Globals.CatCoins)
	$"gold coin amount".text = str(Globals.GoldCatCoins)
	$"diamond coint amount".text = str(Globals.DiamondCatCoins)

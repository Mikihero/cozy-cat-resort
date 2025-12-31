extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TimerSilver.timeout.connect(_silver)
	$TimerGold.timeout.connect(_gold)
	$TimerDiamond.timeout.connect(_diamond)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_updateCoins()
	pass
	
func _updateCoins() -> void:
	$"silver coin amount".text = str(Globals.CatCoins)
	$"gold coin amount".text = str(Globals.GoldCatCoins)
	$"diamond coint amount".text = str(Globals.DiamondCatCoins)

func _silver():
	$SilverCoinSprite.play()

func _gold():
	$GoldCoinSprite.play()
	
func _diamond():
	$DiamondCoinSprite.play()

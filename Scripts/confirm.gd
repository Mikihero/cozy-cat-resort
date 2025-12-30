extends CanvasLayer

var message_text = ""
var coin_type = ""
var wish_amount:int = 0

@onready var wishing_scene = preload("res://Scenes/wishing.tscn")

func  _ready() -> void:
	if(coin_type == "diamond"):
		if (Globals.DiamondCatCoins < 1):
			message_text = "Not enough diamond catcoins"
			$PanelContainer/VBoxContainer/HBoxContainer/Cancel.visible = false
			$PanelContainer/VBoxContainer/HBoxContainer/Confirm.visible = false
			$PanelContainer/VBoxContainer/OK.visible = true
	elif(coin_type == "gold"):
		if (Globals.GoldCatCoins < 100 * wish_amount):
			message_text = "Not enough gold catcoins"
			$PanelContainer/VBoxContainer/HBoxContainer/Cancel.visible = false
			$PanelContainer/VBoxContainer/HBoxContainer/Confirm.visible = false
			$PanelContainer/VBoxContainer/OK.visible = true
			
	$PanelContainer/VBoxContainer/Message.text = message_text

func _on_cancel_pressed() -> void:
	queue_free() # Replace with function body.


func _on_confirm_pressed() -> void:
	if(coin_type == "diamond"):
		Globals.DiamondCatCoins = Globals.DiamondCatCoins - 1
	elif (coin_type == "gold"):
		Globals.GoldCatCoins = Globals.GoldCatCoins - 100 * wish_amount
	print(Globals.DiamondCatCoins,"	", Globals.GoldCatCoins)
	
	var wishing_instance = wishing_scene.instantiate()
	
	get_tree().root.add_child(wishing_instance)
	
	queue_free()


func _on_ok_pressed() -> void:
	queue_free()

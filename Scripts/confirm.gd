extends CanvasLayer

var message_text = ""
var coin_type = ""
var wish_amount:int = 0

func  _ready() -> void:
	if(coin_type == "diamond"):
		if (Globals.placeholder_diamond_catcoin < 1):
			message_text = "Not enough diamond catcoins"
			$PanelContainer/VBoxContainer/HBoxContainer/Cancel.visible = false
			$PanelContainer/VBoxContainer/HBoxContainer/Confirm.visible = false
			$PanelContainer/VBoxContainer/OK.visible = true
	elif(coin_type == "gold"):
		if (Globals.placeholder_gold_catcoin < 100 * wish_amount):
			message_text = "Not enough gold catcoins"
			$PanelContainer/VBoxContainer/HBoxContainer/Cancel.visible = false
			$PanelContainer/VBoxContainer/HBoxContainer/Confirm.visible = false
			$PanelContainer/VBoxContainer/OK.visible = true
			
	$PanelContainer/VBoxContainer/Message.text = message_text

func _on_cancel_pressed() -> void:
	queue_free() # Replace with function body.


func _on_confirm_pressed() -> void:
	if(coin_type == "diamond"):
		Globals.placeholder_diamond_catcoin = Globals.placeholder_diamond_catcoin - 1
	elif (coin_type == "gold"):
		Globals.placeholder_gold_catcoin = Globals.placeholder_gold_catcoin - 100 * wish_amount
	print(Globals.placeholder_diamond_catcoin,"	", Globals.placeholder_gold_catcoin)
	queue_free()


func _on_ok_pressed() -> void:
	queue_free()

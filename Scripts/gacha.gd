extends Node2D

@export var bg_blue: Texture2D
@export var bg_pink: Texture2D
@export var bg_purple: Texture2D

@onready var popup_scene = preload("res://Scenes/confirm.tscn")
@onready var ok_scene = preload("res://Scenes/ok.tscn")
@onready var wishing_scene = preload("res://Scenes/wishing.tscn")
@onready var backgrond_node = $Banner

var coin_type = ""


func _on_wish_premium_pressed() -> void:
	coin_type = "diamond"
	if (Globals.DiamondCatCoins >= 1):
		var popup_instance = popup_scene.instantiate()
		popup_instance.message_text = "Are you sure you want to spend 1 diamond catcoin?"
		popup_instance.action_to_execute = check_funds
		add_child(popup_instance)
	else:
		var ok_instance = ok_scene.instantiate()
		ok_instance.message_text = "Not enough diamond catcoins"
		add_child(ok_instance)


func _on_wish_1_pressed() -> void:
	coin_type = "gold"
	if (Globals.GoldCatCoins >= 100):
		var popup_instance = popup_scene.instantiate()
		popup_instance.message_text = "Are you sure you want to spend 100 gold catcoins?"
		popup_instance.action_to_execute = check_funds
		add_child(popup_instance)
	else:
		var ok_instance = ok_scene.instantiate()
		ok_instance.message_text = "Not enough gold catcoins"
		add_child(ok_instance)
	

func check_funds():
	if(coin_type == "diamond"):
		Globals.DiamondCatCoins = Globals.DiamondCatCoins - 1
	elif (coin_type == "gold"):
		Globals.GoldCatCoins = Globals.GoldCatCoins - 100
	print(Globals.DiamondCatCoins,"	", Globals.GoldCatCoins)
	
	var wishing_instance = wishing_scene.instantiate()
	
	get_tree().root.add_child(wishing_instance)
	

func _on_banner_1_pressed() -> void:
	backgrond_node.texture = bg_blue
	

func _on_banner_2_pressed() -> void:
	backgrond_node.texture = bg_pink


func _on_banner_3_pressed() -> void:
	backgrond_node.texture = bg_purple	

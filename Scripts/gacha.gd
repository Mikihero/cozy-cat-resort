extends Node2D

@export var banner_cat: Texture2D
@export var banner_material: Texture2D

@onready var popup_scene = preload("res://Scenes/examples/confirm.tscn")
@onready var ok_scene = preload("res://Scenes/examples/ok.tscn")
@onready var wishing_scene = preload("res://Scenes/wishing.tscn")
@onready var banner_image = $"Banner image"
@onready var cat_gacha = $"Cat gacha"
@onready var material_gacha = $"Material gacha"

var coin_type = ""
var selected_banner = "cat"

func _on_diamond_pressed() -> void:
	coin_type = "diamond"
	if (Globals.DiamondCatCoins >= 10):
		var popup_instance = popup_scene.instantiate()
		popup_instance.message_text = "Are you sure you want to spend 10 diamond catcoins?"
		popup_instance.action_to_execute = check_funds
		add_child(popup_instance)
	else:
		var ok_instance = ok_scene.instantiate()
		ok_instance.message_text = "Not enough diamond catcoins"
		add_child(ok_instance)


func _on_gold_pressed() -> void:
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
		Globals.DiamondCatCoins = Globals.DiamondCatCoins - 10
	elif (coin_type == "gold"):
		Globals.GoldCatCoins = Globals.GoldCatCoins - 100
	print(Globals.DiamondCatCoins,"	", Globals.GoldCatCoins)
	
	var wishing_instance = wishing_scene.instantiate()
	get_tree().root.add_child(wishing_instance)	
	
	process_mode = PROCESS_MODE_DISABLED
	wishing_instance.tree_exited.connect(func(): process_mode = PROCESS_MODE_INHERIT)

func _on_cancel_pressed() -> void:
	queue_free()


func _on_cat_gacha_pressed() -> void:
	selected_banner = "cat"
	cat_gacha.z_index = 0
	material_gacha.z_index = -1
	banner_image.texture = banner_cat


func _on_material_gacha_pressed() -> void:
	selected_banner = "materials"
	cat_gacha.z_index = -1
	material_gacha.z_index = 0
	banner_image.texture = banner_material

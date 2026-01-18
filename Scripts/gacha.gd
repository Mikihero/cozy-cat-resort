extends Control

@export var banner_cat: Texture2D
@export var banner_material: Texture2D

@onready var hud: HUD = $"../../.";
@onready var wishing_scene = preload("res://Scenes/wishing.tscn")
@onready var banner_image = $"banner/Banner image"
@onready var cat_gacha = $"tabs/Cat gacha"
@onready var material_gacha = $"tabs/Material gacha"

var coin_type = ""
var selected_banner = "cat"

func _on_diamond_pressed() -> void:
	coin_type = "diamond"
	if (Globals.DiamondCatCoins >= 10):
		hud.popup_confirm("Are you sure you want to spend 10 diamond catcoins?", check_funds)
	else:
		hud.popup_info("Not enough diamond catcoins")


func _on_gold_pressed() -> void:
	coin_type = "gold"
	if (Globals.GoldCatCoins >= 100):
		hud.popup_confirm("Are you sure you want to spend 100 gold catcoins?", check_funds)
	else:
		hud.popup_info("Not enough gold catcoins")
	

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
	self.visible = false;


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

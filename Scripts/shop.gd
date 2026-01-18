extends CanvasLayer

@onready var amount_label = $Buy/HBoxContainer/VBoxContainer/Amount
@onready var material_info = $MaterialInfo
@onready var buy = $Buy
@onready var items_container = $simpleBackground/ScrollContainer/MarginContainer/VBoxContainer
@onready var buy_btn = $Buy/HBoxContainer/Button3

var price = 0
var material_name = ""

func _ready() -> void:
	buy.visible = false
	_connect_all_items(items_container)
	
func _connect_all_items(root_node):
	for child in root_node.get_children():
		if child.has_signal("item_clicked"):
			child.item_clicked.connect(_on_item_selected)
		elif child.get_child_count() > 0:
			_connect_all_items(child)
			
func _on_item_selected(item_name: String, texture: Texture2D, item_price: int):
	buy.visible = true
	amount_label.text = "1"
	material_info.update_ui(item_name,texture)
	buy_btn.text = str(item_price)
	price = item_price
	material_name = item_name
	set_colors()

func _on_cancel_pressed() -> void:
	queue_free()


func _on_plus_pressed() -> void:
	var current_amount = int(amount_label.text)
	current_amount += 1
	set_colors()
	amount_label.text = str(current_amount)
	buy_btn.text = str(current_amount * price)


func _on_minus_pressed() -> void:
	var current_amount = int(amount_label.text)
	if current_amount > 1:
		current_amount -= 1
		set_colors()
		amount_label.text = str(current_amount)
		buy_btn.text = str(current_amount * price)


func _on_button_3_pressed() -> void:
	var current_amount = int(amount_label.text)
	if Globals.inventory.has(material_name):
		Globals.GoldCatCoins -= current_amount * price
		Globals.inventory[material_name] += current_amount
		set_colors()
		
	
func set_colors():
	var current_amount = int(amount_label.text)
	if current_amount * price > Globals.GoldCatCoins:
		buy_btn.add_theme_color_override("font_color", Color.RED)
		buy_btn.add_theme_color_override("font_hover_color", Color.RED)
		buy_btn.add_theme_color_override("font_pressed_color", Color.RED)
		buy_btn.add_theme_color_override("font_hover_pressed_color", Color.RED)
	else:
		buy_btn.add_theme_color_override("font_color", Color.WHITE)
		buy_btn.add_theme_color_override("font_hover_color", Color.WHITE)
		buy_btn.add_theme_color_override("font_pressed_color", Color.WHITE)
		buy_btn.add_theme_color_override("font_hover_pressed_color", Color.WHITE)
		

extends CanvasLayer

@onready var wood_label = $VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/MaterialsCost/HBoxContainer/WoodCost/Wood
@onready var stone_label = $VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/MaterialsCost/HBoxContainer/StoneCost/Stone
@onready var clay_label = $VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/MaterialsCost/HBoxContainer/ClayCost/Clay
@onready var residents_label = $VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/Capacity/HBoxContainer/Capacity/Residents
@onready var list_container = $VBoxContainer/ScrollContainer/MarginContainer/HBoxContainer
@onready var selected_house = $VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/SelectedHouse

var clicked_house = null

func _ready():
	if list_container.get_child_count() > 0:
		setup_house_details(list_container.get_child(0))
		
	for house_button in list_container.get_children():
		house_button.pressed.connect(_on_house_selected.bind(house_button))
		
func _on_house_selected(house):
	clicked_house = house
	setup_house_details(house)
	
func setup_house_details(house):
	if Globals.inventory.get("wood") < house.wood_cost:
		wood_label.add_theme_color_override("font_color",Color.BROWN)
	if Globals.inventory.get("clay") < house.clay_cost:
		clay_label.add_theme_color_override("font_color",Color.BROWN)
	if Globals.inventory.get("stone") < house.stone_cost:
		stone_label.add_theme_color_override("font_color",Color.BROWN)
	wood_label.text = str(house.wood_cost)
	stone_label.text = str(house.stone_cost)
	clay_label.text = str(house.clay_cost)
	residents_label.text = str(house.cat_capacity)
	selected_house.build_img = house.build_img

func _on_cancel_pressed() -> void:
	get_tree().paused = false
	queue_free()


func _on_build_pressed() -> void:
	get_tree().paused = false
	queue_free()

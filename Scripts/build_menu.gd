extends Node2D

@onready var wood_label = $VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/WoodCost/Wood
@onready var stone_label = $VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/StoneCost/Stone
@onready var clay_label = $VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/ClayCost/Clay
@onready var list_container = $VBoxContainer/ScrollContainer/HBoxContainer
@onready var selected_house = $VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/SelectedHouse

var clicked_house = null

func _ready():
	"""if list_container.get_child_count() > 0:
		clicked_house = list_container.get_child(0)
		wood_label.text = str(clicked_house.wood_cost)
		stone_label.text = str(clicked_house.stone_cost)
		clay_label.text = str(clicked_house.clay_cost)
		selected_house.build_img = clicked_house.build_img"""
		
	if list_container.get_child_count() > 0:
		setup_house_details(list_container.get_child(0))
		
	for house_button in list_container.get_children():
		house_button.pressed.connect(_on_house_selected.bind(house_button))
		
func _on_house_selected(house):
	clicked_house = house
	setup_house_details(house)
	
func setup_house_details(house):
	wood_label.text = str(house.wood_cost)
	stone_label.text = str(house.stone_cost)
	clay_label.text = str(house.clay_cost)
	selected_house.build_img = house.build_img

func _on_cancel_pressed() -> void:
	queue_free()

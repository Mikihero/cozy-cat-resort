extends PanelContainer

@export var character_name: String = ""
@export var character_image: Texture2D

@onready var img = $MarginContainer/VBoxContainer/CatImg
@onready var cat_name = $MarginContainer/VBoxContainer/CatName
@onready var select_btn = $MarginContainer/VBoxContainer/Select


func _ready():
	cat_name.text = character_name
	if character_image:
		img.texture = character_image
		
func set_selected_mode(is_selected: bool):
	if is_selected:
		modulate = Color(1, 1, 0.5)
		select_btn.visible = false
	else:
		modulate = Color(1, 1, 1)
		select_btn.visible = true

extends PanelContainer

@export var character_name: String = ""
@export var character_image: Texture2D

@onready var img = $MarginContainer/VBoxContainer/CatImg
@onready var cat_name = $MarginContainer/VBoxContainer/CatName


func _ready():
	cat_name.text = character_name
	if character_image:
		img.texture = character_image

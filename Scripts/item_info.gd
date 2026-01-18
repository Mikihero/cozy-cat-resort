extends PanelContainer

@export var item_name: String
@export var item_img: Texture2D

@onready var img = $"VBoxContainer/TextureRect"
@onready var label = $VBoxContainer/Label

func _ready():
	label.text = item_name
	img.texture = item_img

func update_ui(new_name: String, new_texture: Texture2D):
	label.text = new_name
	img.texture = new_texture

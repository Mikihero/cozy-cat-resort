extends PanelContainer

@export var item_name: String
@export var item_img: Texture2D

@onready var img = $"VBoxContainer/TextureRect"
@onready var label = $VBoxContainer/Label

func _ready():
	label.text = item_name
	img.texture = item_img

extends Button

@export var item_img: Texture2D
@export var item_name: String

@onready var img = $MarginContainer/TextureRect

func _ready():
	img.texture = item_img

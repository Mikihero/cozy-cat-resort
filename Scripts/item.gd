extends Button

signal item_clicked(name: String, texture: Texture2D, price: int)

@export var item_img: Texture2D
@export var item_name: String
@export var price: int

@onready var img = $MarginContainer/TextureRect

func _ready():
	img.texture = item_img
	self.pressed.connect(_on_pressed)

func _on_pressed():
	item_clicked.emit(item_name,item_img,price)

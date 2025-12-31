extends Button

@export var build_img: Texture2D:
	set(value):
		build_img = value
		if is_inside_tree():
			img.texture = value

@export var wood_cost: int
@export var stone_cost: int
@export var clay_cost: int
@export var cat_capacity: int

@onready var img = $MarginContainer/TextureRect

func _ready():
	img.texture = build_img

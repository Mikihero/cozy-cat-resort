extends Button

@onready var arrow = $"horizontal container/arrow node/arrow"
@onready var input_background = $"horizontal container/input item node/input item group node/item background texture"
@onready var output_background = $"horizontal container/output item node/output item group node/item background texture"
@onready var input_group_node = $"horizontal container/input item node/input item group node"
@onready var output_group_node = $"horizontal container/output item node/output item group node"
@onready var input_price_tag = $"input price tag background"

@export var arrow_texture_normal: Texture2D
@export var arrow_texture_pressed: Texture2D
@export var item_background_normal: Texture2D
@export var item_background_pressed: Texture2D
@export var price_tag_normal: Texture2D
@export var price_tag_pressed: Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_down() -> void:
	arrow.texture = arrow_texture_pressed
	input_background.texture = item_background_pressed
	input_group_node.position.y += 6
	output_background.texture = item_background_pressed
	output_group_node.position.y += 6
	input_price_tag.texture = price_tag_pressed
	
func _on_button_up() -> void:
	arrow.texture = arrow_texture_normal
	input_background.texture = item_background_normal
	input_group_node.position.y -= 6
	output_background.texture = item_background_normal
	output_group_node.position.y -= 6
	input_price_tag.texture = price_tag_normal

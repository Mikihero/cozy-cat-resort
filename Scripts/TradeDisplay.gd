extends Button

@onready var manager = $"../../../trade manager"

@onready var arrow = $"horizontal container/arrow node/arrow"
@onready var input_background = $"horizontal container/input item node/input item group node/item background texture"
@onready var output_background = $"horizontal container/output item node/output item group node/item background texture"
@onready var input_group_node = $"horizontal container/input item node/input item group node"
@onready var output_group_node = $"horizontal container/output item node/output item group node"
@onready var input_price_tag = $"input price tag background"
@onready var output_price_tag = $"output price tag background"
@onready var output_item_texture = $"horizontal container/output item node/output item group node/item texture"

@export var arrow_texture_normal: Texture2D
@export var arrow_texture_pressed: Texture2D
@export var item_background_normal: Texture2D
@export var item_background_pressed: Texture2D
@export var price_tag_normal: Texture2D
@export var price_tag_pressed: Texture2D

var trade_item: Variant

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)
	initialize_trades()

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
	output_price_tag.texture = price_tag_pressed
	
func _on_button_up() -> void:
	arrow.texture = arrow_texture_normal
	input_background.texture = item_background_normal
	input_group_node.position.y -= 6
	output_background.texture = item_background_normal
	output_group_node.position.y -= 6
	input_price_tag.texture = price_tag_normal
	output_price_tag.texture = price_tag_normal

func initialize_trades() -> void:
	trade_item = manager.receive_trade_item()
	if trade_item == null:
		queue_free()
		return
	#else:
		#print(trade_item)
	print(trade_item)
	output_item_texture.texture = manager.item_textures_dict[trade_item]
	print(manager.item_textures_dict[trade_item])
	
	

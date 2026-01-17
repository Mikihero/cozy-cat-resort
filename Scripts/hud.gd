class_name HUD extends Control

@onready var margin: MarginContainer = $MarginContainer;
@onready var buttonsTR: HBoxContainer = $MarginContainer/ButtonsTR;
@onready var inventory_button: TextureButton = $MarginContainer/ButtonsTR/Inventory;
@onready var settings_button: TextureButton = $MarginContainer/ButtonsTR/Settings;
@onready var aspect_ratio: AspectRatioContainer = $AspectRatio;
@onready var inventory: Control = $AspectRatio/Inventory;
@onready var settings: Control = $AspectRatio/Settings;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().size_changed.connect(func(): 
		margin.size = get_viewport_rect().size
		aspect_ratio.size = get_viewport_rect().size
	)
	settings_button.pressed.connect(func(): settings.visible = !settings.visible);
	inventory_button.pressed.connect(func(): inventory.visible = !inventory.visible);
	var update_hud_visibility = func(): self.buttonsTR.visible = !(settings.visible || inventory.visible);
	settings.visibility_changed.connect(update_hud_visibility);
	inventory.visibility_changed.connect(update_hud_visibility);
	pass # Replace with function body.

func is_position_on_hud(position: Vector2i) -> bool:
	return Rect2i(buttonsTR.position, buttonsTR.size).encloses(Rect2i(position, Vector2i.ONE))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func is_menu_open() -> bool:
	return settings.visible || inventory.visible;

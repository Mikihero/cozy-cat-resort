class_name HUD extends Control

@onready var margin: MarginContainer = $MarginContainer;

@onready var buttonsTL: HBoxContainer = $MarginContainer/ButtonsTL;
@onready var gatcha_button: TextureButton = $MarginContainer/ButtonsTL/Gacha;

@onready var buttonsTR: HBoxContainer = $MarginContainer/ButtonsTR;
@onready var inventory_button: TextureButton = $MarginContainer/ButtonsTR/Inventory;
@onready var settings_button: TextureButton = $MarginContainer/ButtonsTR/Settings;

@onready var toasts: VBoxContainer = $MarginContainer/Toasts;

@onready var overlay: AspectRatioContainer = $Overlay;
@onready var inventory: Control = $Overlay/Inventory;
@onready var settings: Control = $Overlay/Settings;
@onready var gacha: Control = $Overlay/Gacha;

@onready var popups: BoxContainer = $Popups;
var popup_confirm_scene = preload("res://Scenes/examples/confirm.tscn");
var popup_info_scene = preload("res://Scenes/examples/info.tscn");

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_viewport().size_changed.connect(func():
		margin.size = get_viewport_rect().size
		overlay.size = get_viewport_rect().size
		popups.size = get_viewport_rect().size
	)
	settings_button.pressed.connect(func(): settings.visible = true);
	inventory_button.pressed.connect(func(): inventory.visible = true);
	gatcha_button.pressed.connect(func(): gacha.visible = true);

	overlay.get_children()\
		.filter(func(c): return c is Control)\
		.map(func(c: Control): c.visibility_changed.connect(_on_overlay_visibility_changed))
	
	pass # Replace with function body.

func popup_confirm(message: String, action: Callable):
	popups.visible = true;
	var popup: PopupConfirm = popup_confirm_scene.instantiate();
	popup.message_text = message;
	popup.action_to_execute = action;
	popups.add_child(popup)
	
func popup_info(message: String):
	popups.visible = true;
	var popup: PopupInfo = popup_info_scene.instantiate();
	popup.message_text = message;
	popups.add_child(popup)

func _on_overlay_visibility_changed() -> void:
	self.buttonsTR.visible = !self.is_menu_open()
	self.buttonsTL.visible = !self.is_menu_open()

func is_position_on_hud(pos_v: Vector2i) -> bool:
	var pos = Rect2i(pos_v, Vector2i.ONE);
	return (\
		Rect2i(buttonsTR.position, buttonsTR.size).encloses(pos) || \
		Rect2i(buttonsTL.position, buttonsTL.size).encloses(pos))

func is_menu_open() -> bool:
	return settings.visible || inventory.visible || gacha.visible;

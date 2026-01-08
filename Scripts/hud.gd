class_name HUD extends Control

@onready var buttonsTR: HBoxContainer = $ButtonsTR;
@onready var inventory: TextureButton = $ButtonsTR/Inventory;
@onready var settings: TextureButton = $ButtonsTR/Settings;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func is_position_on_hud(position: Vector2i) -> bool:
	return Rect2i(buttonsTR.position, buttonsTR.size).encloses(Rect2i(position, Vector2i.ONE))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

extends CanvasLayer

@onready var amount_label = $Buy/HBoxContainer/VBoxContainer/Amount
@onready var material_info = $MaterialInfo
@onready var buy = $Buy

func _ready() -> void:
	buy.visible = false

extends CanvasLayer

var message_text = ""

func _ready():
	$ColorRect/PanelContainer/VBoxContainer/Message.text = message_text

func _on_ok_pressed() -> void:
	queue_free()

extends CanvasLayer

var message_text = ""
var action_to_execute: Callable


func  _ready() -> void:			
	$PanelContainer/VBoxContainer/Message.text = message_text

func _on_cancel_pressed() -> void:
	queue_free()

func _on_confirm_pressed() -> void:
	if action_to_execute.is_valid():
		action_to_execute.call()
	
	queue_free()

	

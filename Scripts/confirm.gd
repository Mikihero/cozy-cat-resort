extends CanvasLayer

var message_text = ""
var action_to_execute: Callable
var arguments: Variant

func  _ready() -> void:			
	$ColorRect/PanelContainer/VBoxContainer/Message.text = message_text

func _on_cancel_pressed() -> void:
	queue_free()

func _on_confirm_pressed() -> void:
	if action_to_execute.is_valid():
		if arguments == null:
			action_to_execute.call()
		else:
			action_to_execute.call(arguments)
	
	queue_free()

	

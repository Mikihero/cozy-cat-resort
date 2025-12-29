extends Node2D

@onready var popup_scene = preload("res://Scenes/confirm.tscn")


func _on_wish_pressed() -> void:
	var popup_instance = popup_scene.instantiate()
	add_child(popup_instance)
	# Replace with function body.

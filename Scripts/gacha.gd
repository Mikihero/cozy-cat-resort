extends Node2D

@export var bg_blue: Texture2D
@export var bg_pink: Texture2D
@export var bg_purple: Texture2D

@onready var popup_scene = preload("res://Scenes/confirm.tscn")
@onready var backgrond_node = $Banner


func _on_wish_premium_pressed() -> void:
	var popup_instance = popup_scene.instantiate()
	popup_instance.message_text = "Are you sure you want to spend 1 diamond catcoin?"
	popup_instance.coin_type = "diamond"
	
	add_child(popup_instance)


func _on_wish_1_pressed() -> void:
	var popup_instance = popup_scene.instantiate()
	popup_instance.message_text = "Are you sure you want to spend 100 gold catcoins?"
	popup_instance.coin_type = "gold"
	popup_instance.wish_amount = 1
	
	add_child(popup_instance)


func _on_wish_10_pressed() -> void:
	var popup_instance = popup_scene.instantiate()
	popup_instance.message_text = "Are you sure you want to spend 1000 gold catcoins?"
	popup_instance.coin_type = "gold"
	popup_instance.wish_amount = 10
	
	add_child(popup_instance)


func _on_banner_1_pressed() -> void:
	backgrond_node.texture = bg_blue
	


func _on_banner_2_pressed() -> void:
	backgrond_node.texture = bg_pink


func _on_banner_3_pressed() -> void:
	backgrond_node.texture = bg_purple	

extends Node2D

@export var garyScene = preload("res://Scenes/gary.tscn")
@onready var map = self.get_parent().get_node("map") as Map

var npcs: Array[npc] = []

func _ready() -> void:
	npcs.clear()
	

func spawn_cat(offsetX:float):
	var pos: Vector2i = Map.translate_px_to_coords(
		Vector2i(int(offsetX), 70)
	)

	var new_npc: npc = garyScene.instantiate()
	add_child(new_npc)
	new_npc.set_pos_and_show(pos)
	npcs.append(new_npc)

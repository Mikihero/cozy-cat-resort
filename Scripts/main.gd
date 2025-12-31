extends Node2D

@export var cart_scene = preload("res://Scenes/cart.tscn")
@onready var build_scene = preload("res://Scenes/build_menu.tscn")
@onready var gacha_scene = preload("res://Scenes/gacha.tscn")
@onready var inventory_scene = preload("res://Scenes/inventory.tscn")
@onready var spawn_point = $SpawnPoint
@onready var timer = $Timer

func _ready():
	timer.timeout.connect(_on_timer_timeout)
	spawn_carts()
	
func _on_timer_timeout():
	spawn_carts()
	
func spawn_carts():
	var count = randi_range(1,4)
	var offset = 15
	
	for i in range(count):
		var new_cart = cart_scene.instantiate()
		
		new_cart.position = spawn_point.position
		new_cart.position.x -= i * offset
		
		if i == 0:
			new_cart.is_leader = true
			new_cart.stop_pos = 270
		else:
			new_cart.is_leader = false
			new_cart.stop_pos = 99999
		
		add_child(new_cart)


func _on_build_pressed() -> void:
	var build = build_scene.instantiate()
	get_tree().root.add_child(build)
	
	process_mode = PROCESS_MODE_DISABLED
	build.tree_exited.connect(func(): process_mode = PROCESS_MODE_INHERIT)


func _on_inventory_pressed() -> void:
	var inventory =  inventory_scene.instantiate()
	get_tree().root.add_child(inventory)
	
	process_mode = PROCESS_MODE_DISABLED
	inventory.tree_exited.connect(func(): process_mode = PROCESS_MODE_INHERIT)


func _on_gacha_pressed() -> void:
	var gacha =  gacha_scene.instantiate()
	get_tree().root.add_child(gacha)
	
	process_mode = PROCESS_MODE_DISABLED
	gacha.tree_exited.connect(func(): process_mode = PROCESS_MODE_INHERIT)

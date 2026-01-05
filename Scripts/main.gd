extends Node2D

@export var cart_scene = preload("res://Scenes/cart.tscn")
@onready var spawn_point = $SpawnPoint
@onready var timer = $Timer

@onready var map: Map = $Map
@onready var settings: Control = $CanvasLayer/Settings

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
		
		#new_cart.stop_pos = 272 + (i * -offset)
		
		add_child(new_cart)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if OS.get_keycode_string(event.keycode) == "E" && !event.is_pressed():
			settings.visible = !settings.visible
		
	map.set_process_input(!(settings.visible))
	
	

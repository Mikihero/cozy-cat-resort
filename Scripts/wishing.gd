extends Node2D

@onready var star = $Star

var pulse_tween: Tween
var rotate_tween: Tween
var rotation_counter: int = 0
var can_exit: bool = false

func _ready() -> void:
	start_pulsing()

func start_pulsing():
	if rotate_tween and rotate_tween.is_running():
		return
		
	pulse_tween = create_tween().set_loops()
	pulse_tween.tween_property(star, "scale", Vector2(0.12, 0.12), 1.5)
	pulse_tween.tween_property(star, "scale", Vector2(0.15, 0.15), 1.5)
	

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		handle_star_click()
		
func handle_star_click():
	if pulse_tween:
		pulse_tween.kill()

	if rotate_tween and rotate_tween.is_running():
		rotate_tween.kill()
	
	rotate_star()
		
func rotate_star():
	rotate_tween = create_tween()
	rotation_counter = rotation_counter + 1

	var target_rotation = star.rotation_degrees + 360.0
	
	rotate_tween.tween_property(star, "rotation_degrees", target_rotation, 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	rotate_tween.finished.connect(func():
		if rotation_counter >= 3:
			star.visible = false
			$WorldEnvironment.environment.glow_enabled = false
			show_cat()
		else:
			star.rotation_degrees = fmod(star.rotation_degrees, 360.0)
			start_pulsing()
	)
	
func show_cat():
	$Cat.visible = true
	var tween = create_tween()
	tween.tween_property($Cat, "scale", Vector2(0.2, 0.2), 0.5)
	tween.finished.connect(func():
		can_exit = true
	)
	
func _input(event: InputEvent) -> void:
	if can_exit and event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			queue_free()
	

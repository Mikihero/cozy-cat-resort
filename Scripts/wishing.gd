extends Node2D

@onready var star = $Star

var pulse_tween: Tween
var is_rotating: bool = false

func _ready() -> void:
	start_pulsing()

func start_pulsing():
	pulse_tween = create_tween().set_loops()
	pulse_tween.tween_property(star, "scale", Vector2(0.12, 0.12), 1.5)
	pulse_tween.tween_property(star, "scale", Vector2(0.15, 0.15), 1.5)
	


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		if not is_rotating:
			handle_star_click()
		
func handle_star_click():
	is_rotating = true
	
	if pulse_tween and pulse_tween.is_running():
			pulse_tween.kill()
			
	rotate_star()
		
func rotate_star():
	var tween = create_tween()
	star.rotation_degrees = 0
	tween.tween_property(star, "rotation_degrees", 360, 1.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	
	tween.finished.connect(func():
		is_rotating = false
		start_pulsing()
	)

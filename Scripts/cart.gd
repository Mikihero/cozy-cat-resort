extends Node2D

@onready var detector = $FrontDetector

var speed = 100
var stop_pos = 500
var moving = true
var has_stopped = false
var blocked = false
var is_leader = false

func _ready():
	detector.area_entered.connect(_on_area_entered)
	detector.area_exited.connect(_on_area_exited)
	
	play_bounce()

func _process(delta: float) -> void:
	if is_leader and not has_stopped and position.x >= stop_pos:
		position.x = stop_pos
		moving = false
		has_stopped = true
		start_wait_timer()

	if moving and not blocked:
		position.x += speed * delta
	
	if position.x > 400:
		queue_free()
		
func start_wait_timer():
	await get_tree().create_timer(10.0).timeout
	moving = true
	
func _on_area_entered(area):
	if area.name == "BackArea" and area.get_parent() != self:
		blocked = true
		
func _on_area_exited(area):
	if area.name == "BackArea" and area.get_parent() != self:
		blocked = false
		
func play_bounce():
	var tween = create_tween()
	
	tween.tween_property($Cart, "position:y", -2, 0.1).set_trans(Tween.TRANS_SINE)
	tween.tween_property($Cart, "position:y", 0, 0.1).set_trans(Tween.TRANS_SINE)
	
	var wait_time = 1
	await get_tree().create_timer(wait_time).timeout
	
	if is_inside_tree() and moving and not blocked:
		play_bounce()

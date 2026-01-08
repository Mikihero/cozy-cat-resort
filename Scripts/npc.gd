class_name npc extends Node2D

var map: Map
var goal:Vector2i
var lastPos: Vector2i
var path: Array[Vector2i] = []
var speed = 1
var isWalking = false

func set_pos_and_show(pos:Vector2i):
	map = get_parent().get_parent().get_node("Map") as Map 
	pos.x = clamp(pos.x, 13, 16);
	lastPos = pos
	self.position = Map.translate_coord_to_px(pos)
	$Gary.play("walk")
	goal = Vector2i(randi_range(5, 40), randi_range(10, 42))
	recalculate_path()
	speed = (randf() * 0.5 + 0.75) * 0.2
	isWalking = true

func _physics_process(delta: float) -> void:
	if !isWalking: return
	if (path.is_empty()):
		if (lastPos.x <= 1 || lastPos.y>=46):
			despawn()
			return
		# get path to exit
		var i = randi_range(0, 3)
		if (i == 0):
			goal = Vector2i(0, randi_range(39, 40))
		else:
			if(i == 1):
				goal = Vector2i(47, randi_range(5, 12))
			else:
				goal = Vector2i(0, randi_range(7,21))
		recalculate_path()
	else:
		if (lastPos == path.get(0)):
			path.pop_front()
			return
		var currentPos = Map.translate_px_to_coords(self.position)
		var d = self.position.direction_to(Map.translate_coord_to_px(path.get(0)))
		self.position += d * delta * 100. * speed
		lastPos = currentPos

func recalculate_path():
	path = map.get_best_path(lastPos, goal)

func despawn():
	self.get_parent().get_parent().max_cats+=1
	queue_free()

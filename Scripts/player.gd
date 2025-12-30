class_name Cat extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.play("idle")
	pass # Replace with function body.

var path: Array[Vector2i];
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass 
	
func _physics_process(delta: float) -> void:
	if !path.is_empty():
		var prev = self.position;
		#var d = -(self.position - Vector2(path.get(0)));
		var d = self.position.direction_to(path.get(0))
		#print("d:", d);
		self.position += d * delta * (60./8.);
		#print("dirs: ", self.position.direction_to(path.get(0)), prev.direction_to(path.get(0)))
		if self.position.direction_to(path.get(0)) != prev.direction_to(path.get(0)) || d.length() < 0.1:
			#print("overshot")
			self.position = path.get(0);
		if self.position == Vector2(path.get(0)):
			path.pop_front();
			if path.is_empty():
				self.play("idle");
	pass

func move(position: Vector2i):
	self.play("run");
	var map = self.get_parent().get_node("Map") as Map;
	path = map.get_best_path(map.translare_px_to_coords(self.position), position);
	print(path)
	path = map.translate_coords_to_px(path);
	if path.size() >= 2 && self.position.direction_to(path.get(0)) == -self.position.direction_to(path.get(1)):
		path.pop_front()
	print(path);
	#self.position = Vector2(path.back())
	print(self.position)
	
	pass

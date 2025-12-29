extends Node2D

var entities = [
	#MapEntity.new(Vector2i(0, 0)),
	MapEntity.new(Vector2i(3, 4)),
	MapEntity.new(Vector2i(2, 0)),
	MapEntity.new(Vector2i(3, 7)),
	MapEntity.new(Vector2i(11, 4)),
	MapEntity.new(Vector2i(10, 0)),
	MapEntity.new(Vector2i(11, 6)),
	MapEntity.new(Vector2i(8, 4)),
	MapEntity.new(Vector2i(5, 0)),
	MapEntity.new(Vector2i(9, 3)),
	MapEntity.new(Vector2i(6, 4)),
	MapEntity.new(Vector2i(5, 0)),
	MapEntity.new(Vector2i(7, 7)),
];

var width = 12
var height = 8

var path

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var foreground: TileMapLayer = self.get_node("TileMapForeground");
	for entity in entities:
		print(entity.position);
		
		foreground.set_cell(entity.position, 0, Vector2i(52, 5));
		
	path = self.get_best_path(Vector2i(0, 0), Vector2i(width - 1, height - 1))
	print(path)
	
	pass # Replace with function body.	

func get_best_path(source: Vector2i, destination: Vector2i) -> Array[Vector2i]:
	var h = func (n: Vector2i) -> int:
		return pow(destination.x - n.x,2) + pow(destination.y - n.y, 2)
	var open = [source];
	var closed = self.entities.map(func(m): return m.position);
	#print(closed)
	var from = {};
	
	var g_score = {
		source: 0
	};
	var f_score = {
		source: h.call(source)
	};
	
	while !open.is_empty():
		var current = f_score.find_key(f_score.values().min());
		#print(current)
		#print("g:", g_score, "\nf: ", f_score)
		if current == destination:
			
			var path: Array[Vector2i] = [current];
			while from.has(current):
				current = from[current];
				path.append(current)
			path.reverse()
			print(path)
			return path
		open.remove_at(open.find(current))
		f_score.erase(current)
		var neighbors = [
			current + Vector2i(0, 1), 
			current + Vector2i(0, -1), 
			current + Vector2i(1, 0), 
			current + Vector2i(-1, 0)
		].filter(func(v): return (v.x >=0 && v.y >= 0 && v.x < width && v.y < height));
		#print("n: ", neighbors)
		for neighbor in neighbors:
			if closed.has(neighbor):
				continue
			var score = 	g_score[current]
			#print("n: ", neighbor, " score: ", score)
			if !g_score.has(neighbor) || score < g_score[neighbor]:
				from[neighbor] = current
				g_score[neighbor] = score
				f_score[neighbor] = score + h.call(neighbor)
				if !open.has(neighbor):
					open.append(neighbor)
	var path: Array[Vector2i] = [];
	return path;

func add_entity(entity: MapEntity):
	pass

var num_calls = 0
var index = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	num_calls += 1;
	if num_calls == 60:
		num_calls = 0;
		index += 1;
		var foreground: TileMapLayer = self.get_node("TileMapForeground");
				
		foreground.set_cell(path[clamp(index, 0, path.size())], 0, Vector2i(39, 45));
	pass

extends Node2D

var entities = [];

var width = 0
var height = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var foreground: TileMapLayer = self.get_node("TileMapForeground");
	get_free_tiles()

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

func get_free_tiles() -> Array[Vector2i]:
	var background: TileMapLayer = self.get_node("TileMapBackground");
	var border_tiles = (self.get_node("TileMapBackgroundBorder") as TileMapLayer).get_used_cells();
	var positions = background.get_used_cells().filter(func(c): return !border_tiles.has(c));

	print(border_tiles);
	print(background.get_used_cells().size(), " ", border_tiles.size())
	print(positions.size())

	return Array();

func add_entity(entity: MapEntity):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	pass

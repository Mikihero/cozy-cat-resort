class_name Map extends Node2D

var entities: Array[MapEntity] = [];

var width = 0
var height = 0
var save_thread: Thread;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var ent: Array[MapEntity] = [];
	var bg: TileMapLayer = self.get_node("TileMapBackground");
	var used = bg.get_used_cells();
	width = used.map(func(v): return v.x).max() + 1;
	height = used.map(func(v): return v.y).max() + 1;
	if !FileAccess.file_exists("user://save.json"):
		self.save_to_file();
	var save_file = FileAccess.open("user://save.json", FileAccess.READ);
	var data = JSON.parse_string(save_file.get_line());
	(data.get("entities") as Array).map(MapEntity.deserialize).map(func(e: MapEntity): ent.push_back(e));
	print("load:", ent);
	self.entities = ent;
	
	print(self.entities.size())
	
	self.paint_entities();
	
	save_thread = Thread.new();
	save_thread.start(
		func():
			while true:
				await get_tree().create_timer(1).timeout;
				self.save_to_file();
	)
	pass # Replace with function body.

const TREES = [
	Vector2i(53, 6),
	Vector2i(52, 5),
];
const ROCKS = [
	Vector2i(49,30),
	Vector2i(51,30),
	Vector2i(53,30)
];
const SMALL_HOUSE = Vector2i(21, 12);

func get_entities() -> Array[MapEntity]:
	var blocking = self.get_node("TileMapForegroundBlocking") as TileMapLayer;
	var ent: Array[MapEntity] = []
	for c in blocking.get_used_cells():
		var data = blocking.get_cell_tile_data(c);
		var atlas = blocking.get_cell_atlas_coords(c);
		if data.z_index == 0:
			if TREES.find(atlas) != -1:
				var w = 1 if c == Vector2i(52, 5) else 2;
				ent.push_back(MapEntity.new(Rect2i(c, Vector2i(w, 1)), MapEntity.Type.TREE, atlas))
				
			if ROCKS.find(atlas) != -1:
				ent.push_back(MapEntity.new(Rect2i(c, Vector2i(2, 1)), MapEntity.Type.ROCK, atlas))

			if SMALL_HOUSE == atlas:
				ent.push_back(MapEntity.new(Rect2i(c + Vector2i(0, 1), Vector2i(3, 3)), MapEntity.Type.HOUSE, atlas));
								
	return ent;

func add_entity(entity: MapEntity):
		
	pass

func paint_entities():
	self.entities.map(func(e: MapEntity): self.paint_entity(e));


func paint_entity(e: MapEntity):
	var foreground: TileMapLayer = self.get_node("TileMapForegroundBlocking");
	match e.type:
		MapEntity.Type.TREE:
			if e.area.size.x == 2:
				foreground.set_pattern(e.area.position - Vector2i(0, 1), foreground.tile_set.get_pattern(1))
			else:
				foreground.set_pattern(e.area.position - Vector2i(0, 2), foreground.tile_set.get_pattern(0))
		MapEntity.Type.ROCK:
			var offs = [
				Vector2i(0, -1), Vector2i(1, -1),
				Vector2i(0, 0), Vector2i(1, 0)
			];
			for o in offs:
				foreground.set_cell(e.area.position + o, 0, e.texture + o)
		MapEntity.Type.HOUSE:
			var non_blocking: TileMapLayer = self.get_node("TileMapForegroundNonBlocking");
			match e.area.size:
				Vector2i(3, 3): #small
					foreground.set_pattern(e.area.position - Vector2i(1, 3), foreground.tile_set.get_pattern(2));
					non_blocking.set_cell(e.area.position + Vector2i(-1, 0), 0, Vector2i(17, 0));
					non_blocking.set_cell(e.area.position + Vector2i(-1, -1), 0, Vector2i(12, 0));
					non_blocking.set_cell(e.area.position + Vector2i(-1, -2), 0, Vector2i(17, 0), 1);
					non_blocking.set_cell(e.area.position + Vector2i(0, -2), 0, Vector2i(27, 5));
					non_blocking.set_cell(e.area.position + Vector2i(1, -3), 0, Vector2i(29, 5));
					self.add_child(Smoke.new(e.area.position + Vector2i(1, -3)))


func get_best_path(source: Vector2i, destination: Vector2i) -> Array[Vector2i]:
	var h = func (n: Vector2i) -> int:
		return pow(destination.x - n.x,2) + pow(destination.y - n.y, 2)
	var open = [source];
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
			return path
		open.remove_at(open.find(current))
		f_score.erase(current)
		var neighbors = [
			current + Vector2i(0, 1),
			current + Vector2i(0, -1),
			current + Vector2i(1, 0),
			current + Vector2i(-1, 0),
			#current + Vector2i(1, 1),
			#current + Vector2i(1, -1),
			#current + Vector2i(-1, -1),
			#current + Vector2i(-1, 1)
		].filter(func(v):
			return (v.x >=0 && v.y >= 0 && v.x < width && v.y < height) &&\
			self.is_tile_free(v) &&\
			!self.entities.any(func(e: MapEntity): return e.get_area().encloses(Rect2i(v, Vector2i(1, 1)))) 
		);
		for neighbor in neighbors:

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
	var ret: Array[Vector2i] = [];
	return ret;


func is_tile_free(coords: Vector2i) -> bool:
	if (self.get_node("TileMapBackground") as TileMapLayer).get_cell_atlas_coords(coords) == Vector2i(-1, -1):
		return false;
	if (self.get_node("TileMapBackgroundBorder") as TileMapLayer).get_cell_atlas_coords(coords) != Vector2i(-1, -1):
		return false;
	var foreground = self.get_node("TileMapForegroundBlocking") as TileMapLayer;
	if foreground.get_cell_atlas_coords(coords) != Vector2i(-1, -1) &&\
		foreground.get_cell_tile_data(coords).z_index == 0:
		return false;
		

	return true;


const TAP_THRESHOLD = 0.2;
var touch_start_time = 0;
var has_moved = false;

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		has_moved = true;
		var camera = (self.get_parent().get_node("Camera2D") as Camera2D);
		camera.position -= event.relative;

	if event is InputEventScreenTouch:
		if event.is_pressed():
			has_moved = false;
			touch_start_time = Time.get_ticks_msec() / 1000.0;
		else:
			var player: Cat = self.get_parent().get_node("Player");
			var camera = (self.get_parent().get_node("Camera2D") as Camera2D);
			var time = Time.get_ticks_msec() / 1000.0 - touch_start_time;
			if time < TAP_THRESHOLD && !has_moved:
				player.onMapPressed(self.translate_px_to_coords(event.position + camera.position - Vector2(192, 108)));


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST || what == NOTIFICATION_APPLICATION_PAUSED:
		self.save_to_file();
		get_tree().quit();

static func translate_coord_to_px(pos: Vector2i) -> Vector2i:
	return pos * 16 + Vector2i(8, 8);

static func translate_coords_to_px(pos: Array[Vector2i]) -> Array[Vector2i]:
	var ret: Array[Vector2i] = [];
	for p in pos:
		ret.append(Map.translate_coord_to_px(p));
	return ret

static func translate_px_to_coords(pos: Vector2i) -> Vector2i:
	return Vector2i(pos / 16)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#self.entities = self.get_entities();
	pass

func save_to_file():
	var save_file = FileAccess.open("user://save.json", FileAccess.WRITE);
	var ent = self.get_entities();
	var data = {
		"entities": ent.map(func(e: MapEntity): return e.serialize())
	};
	data = JSON.stringify(data);
	save_file.store_string(data);

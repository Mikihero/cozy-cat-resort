class_name Map extends Node2D

# helper variables
var width = 0;
var height = 0;
const TAP_THRESHOLD = 0.2;
var touch_start_time = 0;
var has_moved = false;

# simplified access
var backgroundLayer:TileMapLayer;
var backgroundBorderLayer:TileMapLayer;
var foregroundBlockingLayer:TileMapLayer;
var staticWalkingBlockingLayer:TileMapLayer; # for stuff like map build in, houses, etc.
var dynamicWalkingBlockingLayer:TileMapLayer; # for stuff like npcs, trees, rocks, etc.
var buildingBlockingLayer:TileMapLayer; # for borders, bridges
var camera:Camera2D;
var player: Cat;

func _ready() -> void:
	# initialize stuff
	self.backgroundLayer = self.get_node("TileMapBackground");
	self.backgroundBorderLayer = self.get_node("TileMapBackgroundBorder");
	self.foregroundBlockingLayer = self.get_node("TileMapForegroundBlocking");
	self.staticWalkingBlockingLayer = self.get_node("TileMapWalkingProhibitedStatic");
	self.dynamicWalkingBlockingLayer = self.get_node("TileMapWalkingProhibitedDynamic");
	self.buildingBlockingLayer = self.get_node("TileMapBuildingProhibited");
	self.camera = self.get_parent().get_node("Camera2D");
	self.player = self.get_parent().get_node("Player")
	# init viewport stuff
	var used = self.backgroundLayer.get_used_cells();
	self.width = used.map(func(v): return v.x).max() + 1;
	self.height = used.map(func(v): return v.y).max() + 1;
	var px = Vector2i(width-1, height-1) * 16;
	self.camera.limit_bottom = px.y;
	self.camera.limit_right = px.x;
	self.camera.set_meta("min_zoom", maxf(
		float(ProjectSettings.get_setting("display/window/size/viewport_height")) / float(px.y), 
		float(ProjectSettings.get_setting("display/window/size/viewport_width")) / float(px.x)
	));
	# initialize saver
	SaveManager.initialize_save(self);
	initialize_blocking_layers()

func get_entities() -> Array[MapEntity]:
	var ret: Array[MapEntity] = []
	for e in self.get_children().filter(func(e): return e is MapEntity):
		ret.push_back(e);
	return ret;

func add_entity(entity: MapEntity) -> bool:
	# check if entity is already on map 
	# Piotrek, is this really necessary tho?
	var index = self.get_children().find(entity);
	if index != -1:
		return false 
	# check if entity can be placed on map
	for i in range(entity.area.size.x):
		for j in range(entity.area.size.y):
			if (!is_tile_free(Vector2i(\
				entity.area.position.x + i, \
				entity.area.position.y +j))): return false
	# add entity
	set_layer_cells(self.staticWalkingBlockingLayer, \
		entity.area.position, \
		entity.area.size, \
		Vector2i(37, 51))
	self.add_child(entity);
	return true

func remove_entity(entity: MapEntity):
	entity.destroyed = true;
	var index = self.get_children().find(entity);
	if index == -1:
		return
	set_layer_cells(self.staticWalkingBlockingLayer, \
		entity.area.position, \
		entity.area.size, \
		Vector2i(-1, -1))
	self.remove_child(entity);

func get_best_path(source: Vector2i, destination: Vector2i) -> Array[Vector2i]:
	var h = func (n: Vector2i) -> int:
		return int(pow(destination.x - n.x,2) + pow(destination.y - n.y, 2))
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
		].filter(func(v):
			return (v.x >=0 && v.y >= 0 && v.x < width && v.y < height) &&\
			self.is_tile_free(v) &&\
			!self.get_entities().any(\
				func(e: MapEntity): \
					return e.area.encloses(Rect2i(v, Vector2i(1, 1)))) 
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
	var pathFinal: Array[Vector2i] = [];
	return pathFinal;

# to walk
func is_tile_free(coords: Vector2i) -> bool:
	var atlasCoords: Vector2i = \
		self.staticWalkingBlockingLayer.get_cell_atlas_coords(coords)
	if (atlasCoords == Vector2i(37,51)):
			return false;
	atlasCoords = self.dynamicWalkingBlockingLayer.get_cell_atlas_coords(coords)
	if (atlasCoords == Vector2i(37,51)):
			return false;
	return true

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		has_moved = true;
		self.camera.position -= event.relative;
		self.camera.position.x = clampi(int(camera.position.x), 
			0, int(floorf((width - 1) * 16 - 384. / camera.zoom.x))
		);
		camera.position.y = clampi(int(camera.position.y), 
			0, int(floorf((height - 1) * 16 - 216. / camera.zoom.y))
		);
		
	if event is InputEventMagnifyGesture:
		var old = Vector2(384. / self.self.cameraera.zoom.x, 216. / self.camera.zoom.y);

		self.camera.zoom = Vector2.ONE * clampf(self.camera.zoom.x * event.factor,\
			self.camera.get_meta("min_zoom", 1.0), 1.0);
		var delta = old - (Vector2(384. / self.camera.zoom.x, 216. / self.camera.zoom.y));
		if event.factor < 1.0:
			self.camera.position += delta / 2;
			self.camera.position.x = clampi(int(self.camera.position.x), 
				0, int(floorf((width - 1) * 16 - (384.) / self.camera.zoom.x))
			);
			self.camera.position.y = clampi(int(self.camera.position.y), 
				0, int(floorf((height - 1) * 16 - (216.) / self.camera.zoom.y))
			);
		else:
			self.camera.position += delta/2;

	if event is InputEventScreenTouch:
		if event.is_pressed():
			has_moved = false;
			touch_start_time = Time.get_ticks_msec() / 1000.0;
		else:
			var time = Time.get_ticks_msec() / 1000.0 - touch_start_time;
			if time < TAP_THRESHOLD && !has_moved:
				var tl = Vector2(\
					self.camera.position.x / self.camera.zoom.x,\
					self.camera.position.y / self.camera.zoom.y)
				var px: Vector2 = event.position + tl;
				px.x /= camera.zoom.x;
				px.y /= camera.zoom.y;
				px = Vector2i(int(px.x), int(px.y));
				self.player.onMapPressed(Map.translate_px_to_coords(px));

	# TODO: remove on release
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP \
		or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:

			# Adjust zoom factor (tweak this value)
			var zoom_factor := 1.1
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom_factor = 1.0 / zoom_factor

			var old := Vector2(
				384.0 / camera.zoom.x,
				216.0 / camera.zoom.y
			)

			camera.zoom = Vector2.ONE * clampf(
				camera.zoom.x * zoom_factor,
				camera.get_meta("min_zoom", 1.0),
				1.0
			)

			var new_size := Vector2(
				384.0 / camera.zoom.x,
				216.0 / camera.zoom.y
			)

			var delta := old - new_size
			camera.position += delta / 2.0

			camera.position.x = clampi(
				int(camera.position.x),
				0,
				int(floorf((width - 1) * 16 - new_size.x))
			)

			camera.position.y = clampi(
				int(camera.position.y),
				0,
				int(floorf((height - 1) * 16 - new_size.y))
			)

func initialize_blocking_layers():
	for i in range(48):
		for j in range(55):
			var coords:Vector2i = Vector2i(i,j);
			var shouldBeBlocked = false
			if self.backgroundLayer.get_cell_atlas_coords(coords) == Vector2i(-1, -1):
				shouldBeBlocked = true
			if self.backgroundBorderLayer.get_cell_atlas_coords(coords) != Vector2i(-1, -1):
				shouldBeBlocked = true
			if self.foregroundBlockingLayer.get_cell_atlas_coords(coords) != Vector2i(-1, -1) &&\
				self.foregroundBlockingLayer.get_cell_tile_data(coords).z_index == 0:
				shouldBeBlocked = true
			if (shouldBeBlocked):
				staticWalkingBlockingLayer.set_cell(coords, 0, Vector2i(37,51))
				buildingBlockingLayer.set_cell(coords, 0, Vector2i(37,51))

static func translate_coord_to_px(pos: Vector2i) -> Vector2i:
	return pos * 16 + Vector2i(8, 8);

static func translate_coords_to_px(pos: Array[Vector2i]) -> Array[Vector2i]:
	var ret: Array[Vector2i] = [];
	for p in pos:
		ret.append(Map.translate_coord_to_px(p));
	return ret

static func translate_px_to_coords(pos: Vector2i) -> Vector2i:
	return Vector2i(pos / 16)

func set_layer_cells(layer:TileMapLayer, start:Vector2i, size:Vector2i, cellStuff:Vector2i):
	for i in range(size.x):
		for j in range(size.y):
			layer.set_cell(start + Vector2i(i, j), 0, cellStuff)

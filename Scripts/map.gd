class_name Map extends Node2D

# helper variables
var width = 0;
var height = 0;

const TAP_THRESHOLD = 0.2;
var touch_start_time = 0;
var has_moved = false;
var children:Array[MapEntity];

# simplified access
var backgroundLayer:TileMapLayer;
var backgroundBorderLayer:TileMapLayer;
var foregroundBlockingLayer:TileMapLayer;
var buildingBlockingLayer:TileMapLayer;
var camera:Camera2D;
var player: Cat;
@onready var hud: HUD = $"/root/Main/CanvasLayer/AspectRatio/HUD";

# map for blocked/unblocked
var grid := PackedByteArray() # 1 if free, 0 if empty
var gridWidth: int;
var gridHeight:int;

func _ready() -> void:
	# initialize access stuff
	self.backgroundLayer = self.get_node("TileMapBackground");
	self.backgroundBorderLayer = self.get_node("TileMapBackgroundBorder");
	self.foregroundBlockingLayer = self.get_node("TileMapForegroundBlocking");
	self.buildingBlockingLayer = self.get_node("TileMapBuildingProhibited");
	self.camera = self.get_parent().get_node("Camera2D");
	self.player = self.get_parent().get_node("Player");
	# init map
	var usedRect = self.backgroundLayer.get_used_rect();
	grid.resize(usedRect.size.x * usedRect.size.y);
	grid.fill(1)
	self.gridWidth = usedRect.size.x;
	self.gridHeight = usedRect.size.y;
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
	self.get_tree().root.size_changed.connect(self.viewport_size_changed)
	# initialize saver
	SaveManager.initialize_save(self);
	# blocking
	initialize_blocking_layers()
	print_grid()

func viewport_size_changed():
	var cam: Camera2D = self.get_parent().get_node("Camera2D");
	var size = cam.get_viewport().get_visible_rect().size;
	cam.position.x = clampi(
		int(cam.position.x), 0, int((width - 1) * 16 - size.x / cam.zoom.x)
	)
	cam.position.y = clampi(
		int(cam.position.y), 0, int(floorf((height - 1) * 16 - size.y / cam.zoom.y))
	);
	var px = Vector2i(width-1, height-1) * 16;
	cam.set_meta("min_zoom", maxf(
		float(ProjectSettings.get_setting("display/window/size/viewport_height")) / float(px.y),
		float(ProjectSettings.get_setting("display/window/size/viewport_width")) / float(px.x)
	));

func get_entities() -> Array[MapEntity]:
	return self.children;

func add_entity(entity: MapEntity) -> bool: # returns false if failed
	# check if entity is already on map
	# commenting it out to see if really neccessary
	#var index = self.get_children().find(entity);
	#if index != -1:
	#	return false
	# check if entity can be placed on map
	for i in range(entity.area.size.x):
		for j in range(entity.area.size.y):
			if (!is_tile_free(Vector2i(\
				entity.area.position.x + i, \
				entity.area.position.y +j))): return false
	# add entity
	set_grid_cells(false, entity.area.position, entity.area.size)
	self.add_child(entity);
	self.children.push_back(entity);
	return true

func remove_entity(entity: MapEntity):
	entity.destroyed = true;
	var index = self.get_children().find(entity);
	if index == -1:
		return
	set_grid_cells(true, entity.area.position, entity.area.size)
	self.remove_child(entity);
	self.children.erase(entity);

func _reconstruct_path(came_from: Dictionary, current: Vector2i) -> Array[Vector2i]:
	var path: Array[Vector2i] = [current]
	while came_from.has(current):
		current = came_from[current]
		path.append(current)
	path.reverse()
	return path

func get_best_path(source: Vector2i, destination: Vector2i, offsets: Array[Vector2i] = []) -> Array[Vector2i]:

	var h = func(n: Vector2i) -> int:
		return abs(destination.x - n.x) + abs(destination.y - n.y)

	var open := MinHeap.new()
	open.push({ pos = source, f = h.call(source) })

	var came_from := {}
	var g_score := { source: 0 }
	var visited := {}

	var best_reachable := source
	var best_h: int = h.call(source)

	while !open.is_empty():
		var current = open.pop().pos

		if visited.has(current):
			continue
		visited[current] = true

		var current_h = h.call(current)
		if current_h < best_h:
			best_h = current_h
			best_reachable = current

		if current == destination:
			return _reconstruct_path(came_from, current)

		for neighbor in [
			current + Vector2i(0, 1),
			current + Vector2i(0, -1),
			current + Vector2i(1, 0),
			current + Vector2i(-1, 0)
		]:
			if neighbor.x < 0 or neighbor.y < 0 or neighbor.x >= width or neighbor.y >= height:
				continue
			if !self.is_tile_free(neighbor):
				continue
			if self.get_entities().any(func(e):
				return e.area.encloses(Rect2i(neighbor, Vector2i(1, 1)))
			):
				continue

			var tentative_g = g_score[current] + 1

			if !g_score.has(neighbor) or tentative_g < g_score[neighbor]:
				came_from[neighbor] = current
				g_score[neighbor] = tentative_g
				open.push({
					pos = neighbor,
					f = tentative_g + h.call(neighbor)
				})

	# === Fallback logic ===
	var candidates: Array[Vector2i] = []

	for offset in offsets:
		var alt = destination + offset
		if came_from.has(alt):
			candidates.append(alt)

	if !candidates.is_empty():
		candidates.sort_custom(func(a, b):
			return g_score[a] < g_score[b]
		)
		return _reconstruct_path(came_from, candidates[0])

	# Closest reachable tile
	return _reconstruct_path(came_from, best_reachable)

# to walk
func is_tile_free(coords: Vector2i) -> bool:
	return is_grid_tile_free(coords.x, coords.y);

func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		has_moved = true;

		var size = self.camera.get_viewport().get_visible_rect().size;
		self.camera.position -= event.relative;
		self.camera.position.x = clampf(self.camera.position.x,
			0., floorf((width - 1) * 16 - size.x / self.camera.zoom.x)
		);
		self.camera.position.y = clampf(self.camera.position.y,
			0., floorf((height - 1) * 16 - size.y / self.camera.zoom.y)
		);

	if event is InputEventMagnifyGesture:
		var size = self.camera.get_viewport().get_visible_rect().size;
		var old = Vector2(size.x / self.camera.zoom.x, size.y / self.camera.zoom.y);

		self.camera.zoom = Vector2.ONE * clampf(self.camera.zoom.x * event.factor, self.camera.get_meta("min_zoom", 1.0), 1.0);

		var delta = old - (Vector2(size.x / self.camera.zoom.x, size.y / self.camera.zoom.y));
		if event.factor < 1.0:
			self.camera.position += delta / 2;
			self.camera.position.x = clampf(self.camera.position.x,
				0., floorf((width - 1) * 16 - (size.x) / self.camera.zoom.x)
			);
			self.camera.position.y = clampf(self.camera.position.y,
				0., floorf((height - 1) * 16 - (size.y) / self.camera.zoom.y)
			);
		else:
			self.camera.position += delta/2;

	if event is InputEventScreenTouch:
		if hud.is_position_on_hud(event.position):
			return
		if event.is_pressed():
			has_moved = false;
			touch_start_time = Time.get_ticks_msec() / 1000.0;
		else:
			var time = Time.get_ticks_msec() / 1000.0 - touch_start_time;
			if time < TAP_THRESHOLD && !has_moved:
				var px = Vector2i(event.position / self.camera.zoom) + Vector2i(camera.position);
				self.player.on_map_pressed(Map.translate_px_to_coords(px));

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

static func translate_coord_to_px(pos: Vector2i) -> Vector2i:
	return pos * 16 + Vector2i(8, 8);

static func translate_coords_to_px(pos: Array[Vector2i]) -> Array[Vector2i]:
	var ret: Array[Vector2i] = [];
	for p in pos:
		ret.append(Map.translate_coord_to_px(p));
	return ret

static func translate_px_to_coords(pos: Vector2i) -> Vector2i:
	return Vector2i(pos / 16)

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
				modify_grid_cell(coords.x, coords.y, false);
				buildingBlockingLayer.set_cell(coords, 0, Vector2i(37,51));

func set_layer_cells(layer:TileMapLayer, start:Vector2i, size:Vector2i, cellStuff:Vector2i):
	for i in range(size.x):
		for j in range(size.y):
			layer.set_cell(start + Vector2i(i, j), 0, cellStuff)

func set_grid_cells(shouldBeFree:bool, posTileCoords: Vector2i, sizeTileCoords:Vector2i):
	for i in range(sizeTileCoords.x):
		for j in range(sizeTileCoords.y):
			self.modify_grid_cell(posTileCoords.x+i, posTileCoords.y+j, shouldBeFree);

func modify_grid_cell(xTileCoords:int, yTileCoords:int, shouldBeFree:bool):
	assert(xTileCoords<self.gridWidth && yTileCoords<self.gridHeight);
	grid[self.gridWidth * xTileCoords + yTileCoords] = 1 if shouldBeFree else 0;

func is_grid_tile_free(xTileCoordArg:int, yTileCoordArg:int) -> bool:
	return grid[self.gridWidth * xTileCoordArg + yTileCoordArg];

func print_grid():
	print("map: ------------------------------------------------")
	for j in range(self.gridHeight):
		var finalString:String = ""
		for i in range(self.gridWidth):
			finalString+=" " if self.is_grid_tile_free(i, j) else "0"
		print(finalString)
	print("-----------------------------------------------------")

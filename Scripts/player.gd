class_name Cat extends AnimatedSprite2D

@onready var footsteps_sound = $Footsteps

var path: Array[Vector2i];
var queuedActions: Array[PlayerAction];
var targetSelector: selector;

var map:Map;

func _ready() -> void:
	self.play("idle")
	self.map = self.get_parent().get_node("Map") as Map;
	targetSelector = self.get_parent().get_node("selector") as selector;
	targetSelector.hide_selector()

func _physics_process(delta: float) -> void:
	if !queuedActions.is_empty():
		update_action(delta);
	else:
		if (self.animation.get_basename()!="idle"):
			self.play("idle")
			if footsteps_sound.playing:
				footsteps_sound.stop()

func update_action(delta:float):
	# setup first call
	var currentAction = queuedActions[0]
	if (!currentAction.hasStarted):
		currentAction.hasStarted = true;
		currentAction.hasFinished = false
		self.play(currentAction.getAnimName())
		
		if currentAction.actionEnum == currentAction.ActionEnums.walk:
			if !footsteps_sound.playing:
				footsteps_sound.play()
		
	targetSelector.set_selector_global_position(currentAction.actionPlayerRect);

	#progress and call correct update function
	if (currentAction.isDurationable):
		currentAction.duration -= delta
	
	match currentAction.actionEnum:
		currentAction.ActionEnums.idle:
			pass
		currentAction.ActionEnums.walk:
			move_update(delta)
		currentAction.ActionEnums.axe:
			self.flip_h = self.position.direction_to(currentAction.actionPlayerRect.position).x < 0
		currentAction.ActionEnums.pickaxe:
			self.flip_h = self.position.direction_to(currentAction.actionPlayerRect.position).x < 0
	
	# finish when duration ends or hasFinished flag is set
	if (currentAction.duration<0 && currentAction.isDurationable) || (currentAction.hasFinished):
		finishAction()

func finishAction():
	var a = queuedActions.pop_front();
	if a.entity:
		map.remove_entity(a.entity);
		
	if (queuedActions.size() == 0):
		targetSelector.cool_hide_selector()

func move_update(delta:float):
	if (path.is_empty()):
		queuedActions[0].hasFinished = true
		return
	var prev = self.position;
	# check if path is obstructed (eg. a tree spawned)
	var pathAtZeroTileCoords = Map.translate_px_to_coords(path.get(0)) as Vector2i;
	if (!map.is_tile_free(pathAtZeroTileCoords)):
		self.move(Map.translate_px_to_coords(path.back()));
		if (path.is_empty()):
			# somehow, we ended up in an object. should not happen. 
			# just in case it does, teleport to bridge - safe space :3
			self.position = Map.translate_coord_to_px(Vector2i(5, 23));
			return;
	var d = self.position.direction_to(path.get(0))
	if (abs(d.x)>0):
		self.flip_h = d.x<0
	self.position += d * delta * 40.;
	if self.position.direction_to(path.get(0)) != prev.direction_to(path.get(0)) || d.length() < 0.1:
		self.position = path.get(0);
	if self.position == Vector2(path.get(0)):
		path.pop_front();

enum MoveResult {
	REACH_TARGET,
	NEAREST_BLOCK,
	FAILED
}

# whereTo is in Map coordinates
func move(whereTo: Vector2i, 
		offsets: Array[Vector2i] = [
			Vector2i(-1, 0),
			Vector2i(1, 0),
			Vector2i(0, -1),
			Vector2i(0, 1),
		]) -> MoveResult:
	var result: MoveResult;
	for i in range(offset.length()):
		offset[i] *= 16;
	path = map.get_best_path(Map.translate_px_to_coords(self.position), whereTo, offsets);
	if !path.is_empty():
		if path.back() == whereTo:
			result = MoveResult.REACH_TARGET;
		else:
			result = MoveResult.NEAREST_BLOCK;
	else:
		result = MoveResult.FAILED;
	path = Map.translate_coords_to_px(path);
	if path.size() >= 2 && self.position.direction_to(path.get(0)) == -self.position.direction_to(path.get(1)):
		path.pop_front()
	return result;

func schedule_map_action(target: Vector2i):	
	var index = map.get_entities().find_custom(func(e: MapEntity): return e.area.encloses(Rect2i(target, Vector2i.ONE)));
	if index == -1:
		return;
	
	var action = PlayerAction.new();
	var entity: MapEntity = map.get_entities()[index];
	action.actionPlayerRect = entity.get_sprite_area_in_global_coords();
	action.entity = entity;
	match entity.type:
		MapEntity.Type.TREE:
			move(entity.area.position); #, [Vector2i(-1, 0), Vector2i(entity.area.size.x, 0)]);
			queuedActions.back().actionPlayerRect.position = path.back()
			action.actionEnum = action.ActionEnums.axe;
			action.isDurationable = true;
			action.duration = 5;
		MapEntity.Type.ROCK:
			move(entity.area.position);#, [Vector2i(-1, 0), Vector2i(entity.area.size.x, 0)]);
			queuedActions.back().actionPlayerRect.position = path.back()
			action.actionEnum = action.ActionEnums.pickaxe;
			action.isDurationable = true;
			action.duration = 10;
		MapEntity.Type.HOUSE:
			action.actionEnum = action.ActionEnums.work;
			action.duration = 5;
			action.isDurationable = true;
		_: return;
		
	queuedActions.append(action);
# debug purposes TODO: get rid of this
var flipflop = false
func onMapPressed(mapCoord: Vector2i):
	if (queuedActions.size() == 0):
		var res = move(mapCoord);
		flipflop = !flipflop
		if (flipflop):
			map.add_entity(\
				MapEntity.new(Rect2i(20, 7, 4, 4), MapEntity.Type.HOUSE, \
				MapEntity.house4x4Texture))
			map.add_entity(\
				MapEntity.new(Rect2i(randi_range(10, 20), randi_range(30, 40), 2, 2), MapEntity.Type.ROCK, \
				MapEntity.largeRock2x2Texture))
			map.add_entity(\
				MapEntity.new(Rect2i(randi_range(15, 27), randi_range(15, 22), 2, 2), MapEntity.Type.TREE, \
				MapEntity.largeTree2x2Texture))
		var newAction: PlayerAction = PlayerAction.new();
		newAction.actionEnum = newAction.ActionEnums.walk
		newAction.duration = 0;
		newAction.actionPlayerRect = Rect2i(path.back(), Vector2i.ONE * 24) \
		if !path.is_empty() else Rect2i(Map.translate_coord_to_px(mapCoord), Vector2i.ONE * 24);
		queuedActions.append(newAction);
		match res:
			MoveResult.NEAREST_BLOCK:
				self.schedule_map_action(mapCoord)
	else:	
		if queuedActions.back().actionPlayerRect.encloses(
			Rect2i(Map.translate_coord_to_px(mapCoord), 
			Vector2i.ONE
		)):
			queuedActions.clear();
			targetSelector.cool_hide_selector();	
		else: 
			queuedActions.clear();
			onMapPressed(mapCoord);

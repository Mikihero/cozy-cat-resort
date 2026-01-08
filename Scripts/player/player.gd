class_name Cat extends AnimatedSprite2D

@onready var footsteps_sound = $Footsteps

var path: Array[Vector2i];
var movementSpeed: float = 2.0

var actionQueue:ActionQueue = ActionQueue.new();

var map:Map;

func _ready() -> void:
	self.play("idle")
	self.map = self.get_parent().get_node("Map") as Map;

func _physics_process(delta: float) -> void:
	if (!update_action(delta)):
		if (self.animation.get_basename()!="idle"):
			self.play("idle")
			if footsteps_sound.playing:
				footsteps_sound.stop()

# returns if action was updated (it might not be updated if no action is avaible)
func update_action(delta:float) -> bool:
	if (!actionQueue.should_get_executed()): return false;
	var currentAction:PlayerAction = actionQueue.get_action_to_execute();
	# setup first call
	if (!currentAction.hasStarted):
		currentAction.hasStarted = true;
		self.play(currentAction.get_anim_name())
		
		if currentAction.animEnum == PlayerAction.ActionAnimEnums.walk:
			if !footsteps_sound.playing:
				footsteps_sound.play()

	#progress and call correct update function
	if (currentAction.isDurationable):
		currentAction.duration -= delta
	
	match actionQueue.typeCurrentlyExecuted:
		ActionQueue.ActionTypeEnums.move:
			if (move_update(delta)):actionQueue.get_action_to_execute().hasFinished = true;
		ActionQueue.ActionTypeEnums.gather:
			gather_update(delta)
			
	# finish when duration ends or hasFinished flag is set
	if (currentAction.should_finish()):
		actionQueue.finish_action(self.map)
	return true

# returns if finished moving
func move_update(delta:float)->bool:
	if (path.is_empty()):
		return true
	var prev = self.position;
	# check if path is obstructed (eg. a tree spawned)
	var pathAtZeroTileCoords = Map.translate_px_to_coords(path.get(0)) as Vector2i;
	if (!map.is_tile_free(pathAtZeroTileCoords)):
		self.move(
			Map.translate_px_to_coords(self.position), 
			Map.translate_px_to_coords(path.back())
		);
		if (path.is_empty()):
			# somehow, we ended up in an object. should not happen. 
			# just in case it does, teleport to bridge - safe space :3
			self.position = Map.translate_coord_to_px(Vector2i(5, 23));
			return false;
	var d = self.position.direction_to(path.get(0))
	if (abs(d.x)>0):
		self.flip_h = d.x<0
	self.position += d * delta * 40.;
	if self.position.direction_to(path.get(0)) != prev.direction_to(path.get(0)) || d.length() < 0.1:
		self.position = path.get(0);
	if self.position == Vector2(path.get(0)):
		path.pop_front();
	return false

func gather_update(delta:float):
	var currentAction: PlayerAction = actionQueue.get_action_to_execute();
	if (currentAction.needsToWalkTowardsAction):
		if (currentAction.isWalkingTowardsAction):
			if (!move_update(delta)):
				currentAction.isDurationable = false
				self.play("walk")
			else:
				currentAction.isDurationable = true
				currentAction.needsToWalkTowardsAction = false;
				self.play(currentAction.get_anim_name())
		else:
			move(Map.translate_px_to_coords(self.position), currentAction.actionPlayerPos, \
				[Vector2i(-1, 0), Vector2i(currentAction.selectorRect.size.x, 0)], true);
			currentAction.isWalkingTowardsAction = true;
		return
	else:
		self.flip_h = self.position.direction_to(\
			Map.translate_coord_to_px(actionQueue.get_action_to_execute().selectorRect.position)).x < 0

# debug purposes TODO: get rid of this
var flipflop = false
func on_map_pressed(mapCoord: Vector2i):
	# adding new entities for debug
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
	# get entity
	var index = map.get_entities().find_custom(func(e: MapEntity): return e.area.encloses(Rect2i(mapCoord, Vector2i.ONE)));
	if (index == -1):
		# no entity at clicked- move
		if (!actionQueue.can_add_action(ActionQueue.ActionTypeEnums.move)): return;
		move(Map.translate_px_to_coords(self.position), mapCoord);
		var newAction: PlayerAction = PlayerAction.create(ActionQueue.ActionTypeEnums.move, null);
		newAction.actionPlayerPos = Map.translate_px_to_coords(path.back());
		actionQueue.add_action(newAction, ActionQueue.ActionTypeEnums.move);
	else:
		# entity - add action if possible
		if (!actionQueue.can_add_action(ActionQueue.ActionTypeEnums.gather)): return;
		var entity: MapEntity = map.get_entities()[index];
		var actionType:ActionQueue.ActionTypeEnums = ActionQueue.ActionTypeEnums.gather;
		var newAction:PlayerAction = PlayerAction.create(actionType, entity);
		var result: ActionQueue.actionAddResult =self.actionQueue.add_action(newAction, actionType);
		if (result == ActionQueue.actionAddResult.FAILED): return;
		
		if (result == ActionQueue.actionAddResult.CANCELLED):
			if (path.is_empty() && !actionQueue.should_get_executed()):
				path.push_back(Map.translate_px_to_coords(self.position))
				actionQueue.typeCurrentlyExecuted = ActionQueue.ActionTypeEnums.move
			return
		
		var new_pos = entity.area.position;
		new_pos.y += entity.area.size.y - 1;
		actionQueue.actions.back().actionPlayerPos = new_pos

enum MoveResult {
	REACH_TARGET,
	NEAREST_BLOCK,
	FAILED
}

# whereTo is in Map coordinates
func move(from: Vector2i, whereTo: Vector2i, 
		offsets: Array[Vector2i] = [
			Vector2i(-1, 0),
			Vector2i(1, 0),
			Vector2i(0, -1),
			Vector2i(0, 1),
		], append_to_existing: bool = false) -> MoveResult:
	var result: MoveResult;

	var new_path = map.get_best_path(from, whereTo, offsets);

	if !new_path.is_empty():
		if new_path.back() == whereTo:
			result = MoveResult.REACH_TARGET;
		else:
			result = MoveResult.NEAREST_BLOCK;
	else:
		result = MoveResult.FAILED;
	new_path = Map.translate_coords_to_px(new_path);
	if append_to_existing:
		path.append_array(new_path);
	else:
		path = new_path;
		
	if path.size() >= 2 && self.position.direction_to(path.get(0)) == -self.position.direction_to(path.get(1)):
		path.pop_front()
	return result;

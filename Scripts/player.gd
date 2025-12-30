class_name Cat extends AnimatedSprite2D

var path: Array[Vector2i];
var queuedActions: Array[PlayerAction];
var targetSelector: selector

func _ready() -> void:
	self.play("idle")
	targetSelector = self.get_parent().get_node("selector") as selector;
	targetSelector.hide_selector()
	pass

func _physics_process(delta: float) -> void:
	if !queuedActions.is_empty():
		update_action(delta);
	else:
		if (self.animation.get_basename()!="idle"):
			self.play("idle")

func update_action(delta:float):
	# setup first call
	var currentAction = queuedActions[0]
	if (!currentAction.hasStarted):
		currentAction.hasStarted = true;
		currentAction.hasFinished = false
		self.play(currentAction.getAnimName())
		
	targetSelector.set_selector_position(currentAction.actionPlayerPos, Vector2i(1, 1))
	#progress and call correct update function
	if (currentAction.isDurationable):
		currentAction.duration -= delta
	
	match currentAction.actionEnum:
		currentAction.ActionEnums.idle:
			pass
		currentAction.ActionEnums.walk:
			move_update(delta)
	
	# finish when duration ends or hasFinished flag is set
	if (currentAction.duration<0 && currentAction.isDurationable) || (currentAction.hasFinished):
		finishAction()
	pass

func finishAction():
	queuedActions.pop_front()
	if (queuedActions.size() == 0):
		targetSelector.cool_hide_selector()

func move_update(delta:float):
	if (path.is_empty()):
		queuedActions[0].hasFinished = true
		return
	var prev = self.position;
	var d = self.position.direction_to(path.get(0))
	if (abs(d.x)>0):
		self.flip_h = d.x<0
	self.position += d * delta * 40.;
	if self.position.direction_to(path.get(0)) != prev.direction_to(path.get(0)) || d.length() < 0.1:
		self.position = path.get(0);
	if self.position == Vector2(path.get(0)):
		path.pop_front();
	pass

func move(whereTo: Vector2i):
	var map = self.get_parent().get_node("Map") as Map;
	path = map.get_best_path(map.translare_px_to_coords(self.position), whereTo);
	path = map.translate_coords_to_px(path);
	if path.size() >= 2 && self.position.direction_to(path.get(0)) == -self.position.direction_to(path.get(1)):
		path.pop_front()
	pass

func onMapPressed(mapCoord: Vector2i):
	if (queuedActions.size() == 0):
		move(mapCoord);
		var newAction: PlayerAction = PlayerAction.new();
		newAction.actionEnum = newAction.ActionEnums.walk
		newAction.duration = 0;
		newAction.actionPlayerPos = mapCoord
		queuedActions.append(newAction)
	else:
		if (queuedActions[0].actionEnum == queuedActions[0].ActionEnums.walk):
			move(mapCoord);
			queuedActions[0].actionPlayerPos = mapCoord
	

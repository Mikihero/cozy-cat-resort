class_name PlayerAction

enum ActionAnimEnums {
	idle,
	walk,
	axe,
	pickaxe,
	work
}

# finish checker
var hasStarted:bool;
var hasFinished:bool;
var isDurationable:bool;
var isCancellable:bool;
var isWalkingTowardsAction:bool;
var duration: float;

# selection & display stuff
var actionPlayerPos: Vector2i; # in map coords
var selectorRect: Rect2i;
var animEnum: ActionAnimEnums;

# entity stuff
var shouldDeleteEntityOnFinish:bool;
var entityTarget: MapEntity;

static func create(type:ActionQueue.ActionTypeEnums, entity:MapEntity)->PlayerAction:
	var returnVal:PlayerAction = PlayerAction.new();
	returnVal.hasStarted = false;
	returnVal.hasFinished = false;
	returnVal.isWalkingTowardsAction = true;
	returnVal.actionPlayerPos = Vector2i(-1,-1);
	match  type:
		ActionQueue.ActionTypeEnums.gather:
			returnVal.isDurationable = true;
			returnVal.isCancellable = true;
			returnVal.selectorRect = entity.area;
			returnVal.shouldDeleteEntityOnFinish = true;
			returnVal.entityTarget = entity;
			match entity.type:
				MapEntity.Type.TREE:
					returnVal.duration = 3.0;
					returnVal.animEnum = PlayerAction.ActionAnimEnums.axe;
				MapEntity.Type.ROCK:
					returnVal.duration = 5.0;
					returnVal.animEnum = PlayerAction.ActionAnimEnums.pickaxe;
		
		ActionQueue.ActionTypeEnums.move:
			returnVal.isDurationable = false;
			returnVal.isCancellable = false;
			returnVal.shouldDeleteEntityOnFinish = false;
			returnVal.animEnum = PlayerAction.ActionAnimEnums.walk;
	return returnVal;

func get_anim_name()->String:
	match self.animEnum:
		ActionAnimEnums.idle:
			return "idle"
		ActionAnimEnums.walk:
			return "walk"
		ActionAnimEnums.axe:
			return "axe"
		ActionAnimEnums.pickaxe:
			return "pickaxe"
		ActionAnimEnums.work:
			return "work"
	return "idle";

func should_finish()-> bool:
	return (self.hasFinished || (self.isDurationable && self.duration<0.));

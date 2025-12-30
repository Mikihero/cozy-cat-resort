class_name PlayerAction

enum ActionEnums {
	idle,
	walk,
	axe,
	pickaxe
}

var actionEnum: ActionEnums
var actionPlayerPos: Vector2
var actionActionStuff: Rect2
var hasStarted: bool
var hasFinished:bool
var isDurationable:bool
var duration: float

func getAnimName()->String:
	match actionEnum:
		ActionEnums.idle:
			return "idle"
		ActionEnums.walk:
			return "walk"
		ActionEnums.axe:
			return "axe"
		ActionEnums.pickaxe:
			return "pickaxe"
	return "idle";

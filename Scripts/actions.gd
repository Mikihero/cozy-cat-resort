class_name PlayerAction

enum ActionEnums {
	idle,
	walk,
	axe,
	pickaxe,
	work
}

var actionEnum: ActionEnums
var actionPlayerRect: Rect2i
var hasStarted: bool
var hasFinished:bool
var isDurationable:bool
var duration: float
var entity: MapEntity

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
		ActionEnums.work:
			return "work"
	return "idle";

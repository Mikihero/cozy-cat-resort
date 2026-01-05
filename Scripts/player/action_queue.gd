class_name ActionQueue

# action queue behavior:
# - holds only one type of action at the same time. 
#	examples:
#	 - player clicked on a tree (gather action added), then immediately
#		clicked on house to be cleaned (should add clean action, but wont since gather action is in the queue)
#	 - player clicked on a tree (gather action added), then immediately
#		clicked on rock (now 2 gather actions are added in the queue)
# - walk action is unique - only one can be in the queue, 
#	and if other action is supposed to be added, the queue behaves as if it was empty
#	example:
#	- player clicked on empty space (move action added: moveAction1) then immedotely
#		clicked on another empty space (queue ovverides moveAction1 with new moveAction2, 
#		queue has one action after all this)
#	- player clicked on empty space (move action added) then immediately
#		clicked on a tree (queue ovverides the previous move action with gather action 
#		queue has one action after all this)

enum ActionTypeEnums {
	gather,
	move
}

var typeCurrentlyExecuted: ActionTypeEnums;
var actions:Array[PlayerAction]

func can_add_action(type: ActionTypeEnums)-> bool:
	return (self.actions.is_empty() || self.typeCurrentlyExecuted == type);

# can either add action or cancel action. returns true if cancelled or added, false if didnt do anything 
func add_action(action:PlayerAction, type: ActionTypeEnums)->bool: 
	if (can_add_action(type)):
		var actionIndex:int = can_be_cancelled(action);
		if (actionIndex == -1):
			self.actions.push_back(action);
		else:
			self.actions.remove_at(actionIndex);
		self.typeCurrentlyExecuted = type
		return true;
	return false;

func should_get_executed()-> bool:
	return !self.actions.is_empty();

func get_action_to_execute()->PlayerAction:
	return self.actions[0];

func can_be_cancelled(actionArg:PlayerAction)-> int: # -1 if cannot be, index of object in queue if yes 
	if (!actionArg.isCancellable): return -1;
	for i in range(self.actions.size()):
		var action = self.actions[i];
		if (actionArg.entityTarget == action.entityTarget):
			return i;
	return -1;

func finish_action(mapArg:Map):
	var actionToFinish:PlayerAction = self.actions.front()
	if actionToFinish.shouldDeleteEntityOnFinish:
		mapArg.remove_entity(actionToFinish.entityTarget);
	self.actions.pop_front();

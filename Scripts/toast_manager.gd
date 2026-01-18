extends Node

var toast_queue: Array[Toast] = [];
var mutex = Mutex.new();
var toast_node: VBoxContainer;
# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#toast_node = get_node("")
	#pass # Replace with function body.
var placeholders: Array[Toast] = []

func initialize():
	toast_node = ($"/root/Main/CanvasLayer/HUD" as HUD).toasts;
	for i in range(3):
		var t = Toast.placeholder("");
		t.started = true;
		placeholders.append(t);
		toast_node.add_child(t);

func toast(message: String, time_ms: int = 1000):
	var toast: Toast = Toast.create(message, time_ms);
	toast_queue.append(toast);
	if toast_queue.size() <= 3:
		mutex.lock()
		toast_node.remove_child(placeholders[3 - toast_queue.size()])
		toast_node.add_child(toast);
		toast.start(toast_finish);
		mutex.unlock()
	#toast_node.get_children().filter(func(c): return c is Toast).map(func(c: Toast): print(c.started))

func toast_finish(toast: Toast):
	mutex.lock();
	toast_queue.pop_front();
	toast_node.remove_child(toast)
	
	var p_idx = toast_node.get_children().reduce(func(accum, t): return accum + 1 if t is Toast && t.is_placeholder else accum, 0);

	if p_idx < 3:
		toast_node.add_child(placeholders[p_idx]);
		toast_node.move_child(placeholders[p_idx], p_idx);
	if !toast_queue.is_empty():
		var last_visible_idx = mini(2, toast_queue.size() - 1);
		var last_visible = toast_queue.get(last_visible_idx);
		if !last_visible.started:
			toast_node.remove_child(placeholders[2 - last_visible_idx]);
			toast_node.add_child(last_visible);
			last_visible.start(toast_finish);
	mutex.unlock();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

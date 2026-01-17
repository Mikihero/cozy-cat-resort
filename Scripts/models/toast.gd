class_name Toast extends Node

var timer: Timer;
var time_ms: int;
var message: RichTextLabel;
var started: bool = false;
var finished: bool = false;
var callback: Callable;
var is_placeholder:bool =  false;
static var scene: PackedScene = preload("res://Scenes/toast.tscn");

static func placeholder(message: String = "") -> Toast:
	var t = Toast.create(message);
	t.is_placeholder = true;
	return t;

static func create(message: String, time_ms: int = 1000) -> Toast:
	var toast = scene.instantiate();
	toast.message = toast.get_node("RichTextLabel");
	toast.timer = toast.get_node("Timer");
	toast.message.text = message;
	toast.time_ms = time_ms
	return toast

func start(callback: Callable):
	self.callback = callback;
	self.timer.timeout.connect(func (): self.finished = true);
	self.started = true;
	self.timer.start(float(time_ms) / 1000.)
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if finished:
		message.modulate.a = maxf(0, message.modulate.a - delta);
	
	if message.modulate.a == 0.:
		callback.call(self);
	
	pass

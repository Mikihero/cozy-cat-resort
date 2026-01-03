class_name ActionBubble extends Area2D

enum BubbleType{
	BUBBLE_CLEANING
}

var bubbleAnim: AnimatedSprite2D;
var bubbleType: BubbleType;
var clickCallback: Callable;

func _ready() -> void:
	self.hide()
	self.bubbleAnim = self.get_node("bubble anim") as AnimatedSprite2D
	$Area2D.input_event.connect(onClick)

func create_bubble(typeArg:BubbleType, onClickCallback:Callable):
	self.bubbleType = typeArg
	self.clickCallback = onClickCallback
	switch_anim()
	self.show()

func switch_anim():
	match(self.bubbleType):
		BubbleType.BUBBLE_CLEANING:
			bubbleAnim.play("cleaning")

func onClick(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton and event.pressed)\
	|| (event is InputEventScreenTouch and event.pressed):
		print("Clicked!")
		if (self.clickCallback.call() as bool):
			self.hide()
			queue_free()

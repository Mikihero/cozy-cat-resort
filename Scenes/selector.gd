class_name selector extends Node2D

var bottom: NinePatchRect
var top: NinePatchRect
var map: Map
var animTime: float
var isShown: bool = false

func _ready():
	bottom = $bottom as NinePatchRect
	top = $top as NinePatchRect
	map = self.get_parent().get_node("Map") as Map;
	animTime = 0.
	self.hide()

func _process(delta: float):
	if (!isShown):
		hide()
	else:
		show()
	if (animTime > 0):
		animTime = clamp(animTime - delta, 0, 1)
		var animScale:float = 1 - (-2 * pow((animTime * 2.- 0.3), 2) + 1)
		self.scale = Vector2(animScale, animScale)
		if (animTime==0):
			isShown = false

func set_selector_position(rect: Rect2i):
	var pixelPos = map.translate_coord_to_px(rect.position) + Vector2i(5, 2);
	var pixelSize:Vector2i = map.translate_coord_to_px(rect.size) + Vector2i(6, 8);
	top.size = pixelSize
	bottom.size = pixelSize
	self.position = pixelPos
	self.scale = Vector2(1, 1)
	self.visible = true
	self.isShown = true

func hide_selector():
	self.visible = false

func cool_hide_selector():
	animTime = 0.5

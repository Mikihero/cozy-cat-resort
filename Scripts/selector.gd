class_name selector extends Node2D

var bottom: NinePatchRect
var top: NinePatchRect
#var map: Map
var animTime: float
var isShown: bool = false

func _ready():
	bottom = $bottom as NinePatchRect
	top = $top as NinePatchRect
	#map = self.get_parent().get_node("Map") as Map;
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
	self.set_selector_global_position(
		Rect2i(
			Map.translate_coord_to_px(rect.position), 
			Map.translate_coord_to_px(rect.size)
		)
	);

func set_selector_global_position(rect: Rect2i):
	if (rect.size.x / 16) % 2 == 1:
		rect.position.x += 4;
	else:
		rect.position.x -= 4;
		rect.size.x += 8;
		
	if (rect.size.y / 16) % 2 == 1:
		rect.position.y += 4;
	else:
		rect.position.y -= 4;
		rect.size.y += 8;
	var pixelPos = rect.position;
	var pixelSize:Vector2i = rect.size + Vector2i(8, 8)# + Vector2i(24, 24);
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

class_name MapEntity extends Sprite2D

@export var actionBubbleScene = preload("res://Scenes/entities/action_bubble_scene.tscn")
static var house4x4Texture = preload("res://Assets/entities/house/4x4.png")
static var largeRock2x2Texture = preload("res://Assets/entities/rock/large.png")
static var largeTree2x2Texture = preload("res://Assets/entities/tree/large.png")

enum Type {
	TREE = 0,
	ROCK = 1,
	HOUSE = 2
}

var area: Rect2i;
var type: MapEntity.Type;
var destroyed: bool = false;

# creation/deletion
func _init(areaArg: Rect2i, typeArg: Type, textureArg: CompressedTexture2D):
	self.area = areaArg
	self.type = typeArg
	self.texture = textureArg
	self.z_index = 10;
	var posOffset = Vector2(area.size * 8) - Vector2(8, 8)
	self.position = Vector2(Map.translate_coord_to_px(area.position)) + posOffset

func destroy():
	print("destroyed")
	self.destroyed = true;
	self.get_parent().remove_child(self);

# coords utils
func get_sprite_area_in_global_coords() -> Rect2i:
	var ret = self.area;
	ret.position = (ret.position) * 16;
	ret.size = ret.size * 16;
	return ret;

# TODO: finish those bubbles
func create_bubble(typeArg: ActionBubble.BubbleType):
	var bubble = actionBubbleScene.instantiate()
	bubble.create_bubble(typeArg, on_bubble_click())

func on_bubble_click() -> bool:
	return true;
	
# de/serialization utils
static func deserialize(dataArg: Dictionary) -> MapEntity:
	return MapEntity.new(
		Rect2i(dataArg.get("position_x"), dataArg.get("position_y"), dataArg.get("size_x"), dataArg.get("size_y")), 
		Type.values().find_custom(func(v): return (v as int) == (dataArg.get("type") as int)),
		load(dataArg.get("texture"))
	);

func serialize() -> Dictionary:
	return {
		"position_x": area.position.x,
		"position_y": area.position.y,
		"size_x": area.size.x,
		"size_y": area.size.y,
		"type": type,
		"texture": texture.resource_path
	};

func _to_string() -> String:
	return str(self.area) + " " + str(self.type)

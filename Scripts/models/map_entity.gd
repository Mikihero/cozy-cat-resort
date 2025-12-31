class_name MapEntity

var area: Rect2i;
var type: MapEntity.Type;
var texture: Vector2i;

func _init(area: Rect2i, type: Type, texture: Vector2i):
	self.area = area
	self.type = type
	self.texture = texture
	pass

func _to_string() -> String:
	return str(self.area) + " " + str(self.type)

func serialize() -> String:
	return JSON.stringify({
		"position_x": area.position.x,
		"position_y": area.position.y,
		"size_x": area.size.x,
		"size_y": area.size.y,
		"type": type,
		"texture_x": texture.x,
		"texture_y": texture.y
	});
	
static func deserialize(str: String) -> MapEntity:
	var data: Dictionary = JSON.parse_string(str);
	return MapEntity.new(
		Rect2i(data.get("position_x"), data.get("position_y"), data.get("size_x"), data.get("size_y")), 
		Type.values().find_custom(func(v): return (v as int) == (data.get("type") as int)),
		Vector2i(data.get("texture_x"), data.get("texture_y"))
	);

func get_area() -> Rect2i:
	var ret = self.area;
	match self.type:
		Type.HOUSE: 
			ret.position.y -= (ret.size.y - 1)
	return ret;

func get_sprite_area() -> Rect2i:
	var ret = self.area;
	match self.type:
		Type.TREE:
			if self.area.size.x == 2:
				ret.position.y -= 1;
				ret.size.y += 1;
			else:
				ret.position.y -= 1;
				ret.size.y += 1;
		Type.HOUSE:
			match self.area.size:
				Vector2i(3, 3):
					ret.position.y -= 2;
	return ret;

func get_sprite_area_in_global_coords() -> Rect2i:
	var ret = self.get_sprite_area();
	ret.position = Map.translate_coord_to_px(ret.position);
	ret.size = Map.translate_coord_to_px(ret.size);
	
	match self.type:
		Type.HOUSE:
			match self.area.size:
				Vector2i(3, 3):
					ret.position -= Vector2i(8, 8);
					ret.size += Vector2i(16, 8);
	
	return ret;

enum Type {
	TREE = 0,
	ROCK = 1,
	HOUSE = 2,
	CART_WORK = 3
}

class_name MapEntity extends Sprite2D

var area: Rect2i;
var type: MapEntity.Type;
var destroyed: bool = false;

func _init(area: Rect2i, type: Type, texture: CompressedTexture2D):
	self.area = area
	self.type = type
	self.texture = texture
	self.position = Map.translate_coord_to_px(area.position)
	self.z_index = 10;
	
	match self.type:
		Type.TREE:
			self.position.x += 8;
		Type.ROCK:
			self.position.x += 8;
			self.position.y -= 8;
		Type.HOUSE:
			var pos: Vector2i;
			match self.area.size:
				Vector2i(3, 3):
					self.position.x += 16;
					self.position.y -= 24;
					pos = Vector2i(0, -32)
			self.add_child(Smoke.new(pos))
	pass

func destroy():
	print("destroyed")
	self.destroyed = true;
	self.get_parent().remove_child(self);

func _to_string() -> String:
	return str(self.area) + " " + str(self.type)

func serialize() -> String:
	return JSON.stringify({
		"position_x": area.position.x,
		"position_y": area.position.y,
		"size_x": area.size.x,
		"size_y": area.size.y,
		"type": type,
		"texture": texture.resource_path
	});
	
static func deserialize(str: String) -> MapEntity:
	var data: Dictionary = JSON.parse_string(str);
	return MapEntity.new(
		Rect2i(data.get("position_x"), data.get("position_y"), data.get("size_x"), data.get("size_y")), 
		Type.values().find_custom(func(v): return (v as int) == (data.get("type") as int)),
		load(data.get("texture"))
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
		Type.ROCK:
			ret.position.y -= 1;
			ret.size.y += 1;
		Type.HOUSE:
			match self.area.size:
				Vector2i(3, 3):
					ret.position.y -= 2;
	return ret;

func get_sprite_area_in_global_coords() -> Rect2i:
	var ret = self.get_sprite_area();
	ret.position = (ret.position + Vector2i.ONE) * 16;
	ret.size = ret.size * 16;
	
	match self.type:
		Type.HOUSE:
			match self.area.size:
				Vector2i(3, 3):
					ret.position -= Vector2i(8, 16);
					ret.size += Vector2i(16, 16);
					pass
	return ret;

enum Type {
	TREE = 0,
	ROCK = 1,
	HOUSE = 2,
	CART_WORK = 3
}

class_name MapEntity

var position;

func _init(position: Vector2i):
	self.position = position
	pass
	
enum Type {
	Border,
	Water,
	Tree,
	Rock,
	House
}

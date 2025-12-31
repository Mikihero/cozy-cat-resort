class_name Smoke extends CPUParticles2D

var coords: Vector2i;

func _init(coords: Vector2i = Vector2i(8, 8)) -> void:
	self.coords = coords;
	#var material = ParticleProcessMaterial.new();
	self.z_index = 99;
	#material.gravity.y = 1;
	#self.set_texture(null);	
	#self.material = material;
	
	self.gravity.y = 0;
	self.initial_velocity_min = 30;
	self.initial_velocity_max = 30;
	self.rotation_degrees = -90;
	self.angle_min = -5.0;
	self.angle_max = 5.0;
	self.spread = 10;
	self.emission_shape = CPUParticles2D.EMISSION_SHAPE_SPHERE;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.position = (self.get_parent() as Map).translate_coord_to_px(self.coords) - Vector2i(0, 8);
	self.amount = 128;
	self.emission_sphere_radius = 4;
	
	#self.emit_particle(Transform2D(0., Vector2i(50, 50), 0., Vector2i.ZERO), Vector2i(0, 60), Color.WHITE, Color(0., 0., 0., 50.), 2);
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

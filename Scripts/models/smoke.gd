class_name Smoke extends CPUParticles2D

var _pos: Vector2i;

func _init(position: Vector2i = Vector2i(8, 8)) -> void:
	self._pos = position;
	#var material = ParticleProcessMaterial.new();
	#material.set_particle_flag(ParticleProcessMaterial.ParticleFlags.PARTICLE_FLAG_DISABLE_Z, true);
	#material.gravity.y = 1;
	#self.set_texture(null);	
	#self.material = material;
	self.gravity.y = 0;
	self.initial_velocity_min = 100;
	self.initial_velocity_max = 100;
	self.emission_shape = CPUParticles2D.EMISSION_SHAPE_SPHERE;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.position = (self.get_parent() as Map).translare_px_to_coords(_pos);
	self.amount = 8;
	self.emission_sphere_radius = 8;
	
	#self.emit_particle(Transform2D(0., Vector2i(50, 50), 0., Vector2i.ZERO), Vector2i(0, 60), Color.WHITE, Color(0., 0., 0., 50.), 2);
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

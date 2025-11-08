extends GPUParticles2D


var parent_node;
var EMISSION_SCALE_FACTOR = 0.004;

func _ready():
	parent_node = get_parent();
	if !parent_node: print("Parent RigidBody not found in Tentacle!");
		
func _process(_delta) -> void:
	var vel = parent_node.linear_velocity;
	# number of particles depending on speed
	amount_ratio = EMISSION_SCALE_FACTOR*(vel.length());

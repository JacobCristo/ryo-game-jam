class_name FireProjectile extends Projectile

var starting_pos: Vector2 = Vector2.ZERO #store starting pos
var projectile_range: float = 200000.0

func _ready() -> void:
	super._ready()
	starting_pos = global_position

func _process(delta: float) -> void:
	move(delta)
	
	# free projectile from scene after traveling far enough
	if global_position.distance_squared_to(starting_pos) >= projectile_range:
		queue_free()

## Progress towards direction at constant speed
func move(delta: float) -> void:
	position += direction.normalized() * speed * delta
	rotation = direction.angle()

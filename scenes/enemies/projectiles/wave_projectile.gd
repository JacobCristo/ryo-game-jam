class_name WaveProjectile extends Projectile

@export var frequency: float = 5.0
@export var amplitude: float = 1.0

var time: float = 0.0
var dir: Vector2
var perp: Vector2

func _ready() -> void:
	super._ready()
	
	# Lock the initial direction and perpendicular vector
	dir = direction.normalized()
	perp = Vector2(-dir.y, dir.x)

func _physics_process(delta: float) -> void:
	move(delta)

## Progress towards direction at constant speed with sinusoidal offset
func move(delta: float) -> void:
	var forward_velocity = dir * speed * delta
	var wave_offset = perp * sin(time * frequency) * amplitude
	
	global_position += forward_velocity + wave_offset
	
	time += delta

class_name BasicProjectile extends Projectile

var damage = 10.0

func _process(delta: float) -> void:
	move(delta)

## Progress towards direction at constant speed
func move(delta: float) -> void:
	global_position += direction * speed * delta

func hit(body: Node2D) -> void:
	if body is Player:
		var player = body as Player 
		player.take_damage(damage)

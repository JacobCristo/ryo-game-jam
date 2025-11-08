class_name SniperProjectile extends Projectile

func _process(delta: float) -> void:
	move(delta)

## Progress towards direction at constant speed
func move(delta: float) -> void:
	position += direction.normalized() * speed * delta
	rotation = direction.angle()

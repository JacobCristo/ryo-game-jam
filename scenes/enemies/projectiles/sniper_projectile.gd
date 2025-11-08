class_name SniperProjectile extends Projectile

func _process(delta: float) -> void:
	move(delta)

## Progress towards direction at constant speed
func move(delta: float) -> void:
	position += direction.normalized() * speed * delta
	rotation = direction.angle()

func hit(body: Node2D) -> void:
	if body is Player:
		var player = body as Player 
		player.take_damage(damage)

@abstract class_name Projectile extends Area2D

var direction: Vector2 = Vector2.ZERO
var speed: float = 250.0

func _process(delta: float) -> void:
	move(delta)

## Determine movement based on projectile type
@abstract func move(delta: float) -> void

## Determine hit effect based on projectile type
@abstract func hit(body: Node2D) -> void

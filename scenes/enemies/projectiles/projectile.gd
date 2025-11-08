@abstract class_name Projectile extends Area2D

@export var speed: float = 5.0
@export var damage: float = 10.0

var direction: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	move(delta)

## Determine movement based on projectile type
@abstract func move(delta: float) -> void

## Determine hit effect based on projectile type
@abstract func hit(body: Node2D) -> void

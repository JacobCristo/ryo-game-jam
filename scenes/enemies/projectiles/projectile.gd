@abstract class_name Projectile extends Area2D

@export var speed: float = 5.0
@export var damage: float = 10.0
@export var projectile_size: float = 3.0

var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	$CollisionShape2D.shape.radius = 10 * projectile_size
	$Polygon2D.scale = Vector2(projectile_size, projectile_size)
	
func _process(delta: float) -> void:
	move(delta)

## Determine movement based on projectile type
@abstract func move(delta: float) -> void

## Determine hit effect based on projectile type
@abstract func hit(body: Node2D) -> void

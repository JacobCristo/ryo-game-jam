@abstract class_name Projectile extends Area2D

const EXPLOSION = preload("uid://ckaq3lr1gba6l")

@export var speed: float = 1500.0
@export var damage: float = 10.0
@export var projectile_size: float = 3.0

var direction: Vector2 = Vector2.ZERO
var hits_player: bool = true

func _ready() -> void:
	$CollisionShape2D.shape.radius = 10 * projectile_size
	$Sprite2D.scale = Vector2(projectile_size, projectile_size)
	
func _process(delta: float) -> void:
	move(delta)

## Determine movement based on projectile type
@abstract func move(delta: float) -> void

## Determine hit effect based on projectile type
func hit(body: Node2D) -> void:
	if body is Player:
		var player = body as Player
		player.take_damage(damage)
		
	if body.name == "ObstacleLayer":
		var explosion = EXPLOSION.instantiate()
		explosion.global_position = global_position
		get_tree().current_scene.call_deferred("add_child", explosion)
		
		queue_free()

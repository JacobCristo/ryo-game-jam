class_name Obstacle extends RigidBody2D

const EXPLOSION = preload("uid://ckaq3lr1gba6l")

@onready var sprite: AnimatedSprite2D = $Sprite2D

func _ready() -> void:
	sprite.animation = &"default"
	sprite.frame = randi_range(0, sprite.sprite_frames.get_frame_count("default") - 1)

func _on_body_entered(body: Node) -> void:
	if body is Segment:
		explode()
		
func explode() -> void:
	var explosion = EXPLOSION.instantiate()
	explosion.global_position = global_position
	explosion.scale = Vector2(2, 2)
	
	get_tree().current_scene.call_deferred("add_child", explosion)
	
	queue_free()

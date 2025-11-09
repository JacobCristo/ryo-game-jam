class_name Obstacle extends RigidBody2D

const EXPLOSION = preload("uid://ckaq3lr1gba6l")
const GOOPPICKUP = preload("uid://b2itprytx40ly")
const HEALTHPICKUP = preload("uid://c5iikbni6ptdk")

@onready var sprite: AnimatedSprite2D = $Sprite2D

func _ready() -> void:
	sprite.animation = &"default"
	sprite.frame = randi_range(0, sprite.sprite_frames.get_frame_count("default") - 1)

func _on_body_entered(body: Node) -> void:
	if body is Segment or body is Enemy:
		explode()
		
func explode() -> void:
	var explosion = EXPLOSION.instantiate()
	explosion.global_position = global_position
	explosion.scale = Vector2(2, 2)
	get_tree().current_scene.call_deferred("add_child", explosion)
	if randi() % 3:
		if randi() % 2:
			var health_pickup = HEALTHPICKUP.instantiate()
			health_pickup.global_position = global_position
			get_tree().current_scene.call_deferred("add_child", health_pickup)
		else:
			var goop_pickup = GOOPPICKUP.instantiate()
			goop_pickup.global_position = global_position
			get_tree().current_scene.call_deferred("add_child", goop_pickup)
	queue_free()

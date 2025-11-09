class_name Obstacle extends RigidBody2D

const EXPLOSION = preload("uid://ckaq3lr1gba6l")
const HEALTHPICKUP = preload("uid://c5iikbni6ptdk")
const GOOPPICKUP = preload("uid://b2itprytx40ly")

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
	var rand = randi()%3
	get_tree().current_scene.call_deferred("add_child", explosion)
	if (rand == 3):
		rand = randi()%2
		if rand == 2:
			get_tree().current_scene.call_deferred("add_child", HEALTHPICKUP)
		if rand == 1: 
			get_tree().curent_scene.call_deferred("add_child", GOOPPICKUP)
	queue_free()

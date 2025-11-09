class_name Door extends Area2D

@export var next_door_coords: Vector2i = Vector2i.ZERO

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var open: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player and open:
		body.global_postion = next_door_coords

func open_door() -> void:
	open = true
	sprite.play("open")

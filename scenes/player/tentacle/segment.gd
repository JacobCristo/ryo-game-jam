class_name Segment extends Node2D

@onready var collision: CollisionShape2D = $CollisionShape2D

# Literally here to ID segments
func disable() -> void:
	collision.set_deferred("disabled", true)
	
func enable() -> void:
	collision.set_deferred("disabled", false)

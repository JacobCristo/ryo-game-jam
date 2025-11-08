class_name MuzzleFlash extends AnimatedSprite2D

func _on_animation_finished() -> void:
	queue_free()

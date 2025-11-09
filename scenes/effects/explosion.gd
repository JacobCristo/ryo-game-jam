class_name Explosion extends AnimatedSprite2D

@onready var audio = $AudioStreamPlayer2D

func _on_animation_finished() -> void:
	queue_free()


	pass # Replace with function body.


func _on_audio_stream_player_2d_finished() -> void:
	print("exploded")
	pass # Replace with function body.

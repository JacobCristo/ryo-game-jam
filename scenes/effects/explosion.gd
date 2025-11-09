class_name Explosion extends AnimatedSprite2D

@onready var audio = %AudioStreamPlayer2D

func _ready() -> void:
	# audio.pitch_scale = audio.pitch_scale + randf_range(-0.1, 0.1)
	audio.play()
	queue_free()
	pass # Replace with function body.


func _on_audio_stream_player_2d_finished() -> void:
	print("exploded")
	pass # Replace with function body.

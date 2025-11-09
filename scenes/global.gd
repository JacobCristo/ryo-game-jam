extends Node

signal playerHit(damage_taken: float, player_health: float)

# coordinates mapping to room objects (1 to 1)
# Vector2i -> Room
var rooms: Dictionary = {};

func shake_camera(amplitude: float, duration: float) -> void:
	var camera = get_tree().get_first_node_in_group("camera") as Camera2D
	var timer = get_tree().create_timer(duration)
	
	while timer.time_left > 0.0:
		if not camera:
			return
		camera.position = Vector2(randf_range(-amplitude, amplitude), randf_range(-amplitude, amplitude))
		await get_tree().create_timer(0.01).timeout
		
	camera.position = Vector2.ZERO

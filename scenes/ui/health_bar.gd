class_name HealthBar extends ProgressBar

@onready var chunk_bar: ProgressBar = $ChunkBar
@onready var chunk_timer: Timer = $ChunkTimer

var max_health: float = 100.0
var health: float = max_health:
	set(new_health):
		var prev_health = health
		health = clamp(new_health, 0, max_health)
		value = health

		if health < prev_health:
			chunk_timer.start()
		else:
			chunk_bar.value = health

func _ready() -> void:
	max_value = max_health
	chunk_bar.max_value = max_health

func _on_chunk_timer_timeout() -> void:
	get_tree().create_tween() \
		.tween_property(chunk_bar, "value", health, 0.25) \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_OUT)

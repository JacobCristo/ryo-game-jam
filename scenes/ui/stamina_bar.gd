class_name StaminaBar extends ProgressBar

@onready var chunk_bar: ProgressBar = $ChunkBar
@onready var chunk_timer: Timer = $ChunkTimer

var max_goop: float = 100.0
var goop: float = max_goop:

	set(new_goop):
		var prev_goop = goop
		goop = min(max_goop, new_goop)
		value = goop
		
		if goop < prev_goop:
			chunk_timer.start()
		else:
			chunk_bar.value = goop

func _on_chunk_timer_timeout() -> void:
	get_tree().create_tween().tween_property(chunk_bar, "value", goop, 0.25).set_trans(Tween.TRANS_CUBIC)

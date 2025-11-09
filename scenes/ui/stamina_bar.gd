class_name StaminaBar extends ProgressBar

@onready var chunk_bar: ProgressBar = $ChunkBar
@onready var chunk_timer: Timer = $ChunkTimer

var max_stamina: float = 100.0
var stamina: float = max_stamina:

	set(new_stamina):
		var prev_stamina = stamina
		stamina = min(max_stamina, new_stamina)
		value = stamina
		
		if stamina < prev_stamina:
			chunk_timer.start()
		else:
			chunk_bar.value = stamina

func _on_chunk_timer_timeout() -> void:
	get_tree().create_tween().tween_property(chunk_bar, "value", stamina, 0.25).set_trans(Tween.TRANS_CUBIC)

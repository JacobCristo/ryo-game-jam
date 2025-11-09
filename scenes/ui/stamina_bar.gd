class_name StaminaBar extends ProgressBar

@onready var chunk_bar: ProgressBar = $ChunkBar
@onready var chunk_timer: Timer = $ChunkTimer

var goop_timeout = false
var goop_minlevel = 10.0
var default_color = Color(0.9041, 0.0007, 0.9041, 1.0)
var cooldown_color = Color(0.913, 0.432, 0.369, 1.0)

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
			
		if (value < 0.3) :
			goop_timeout = true
			
		if (value < goop_minlevel and goop_timeout):
			self["theme_override_styles/fill"].bg_color = cooldown_color
		else :
			goop_timeout = false
			self["theme_override_styles/fill"].bg_color = default_color



func _on_chunk_timer_timeout() -> void:
	get_tree().create_tween().tween_property(chunk_bar, "value", goop, 0.25).set_trans(Tween.TRANS_CUBIC)

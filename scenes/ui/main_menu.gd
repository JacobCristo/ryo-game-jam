class_name MainMenu extends Control

const EXPLOD = preload("uid://db54u7e8s3dc4")

@onready var texture_rect: TextureRect = $TextureRect
@onready var explosion : AudioStreamPlayer = $Explosion
@onready var label: RichTextLabel = $VBoxContainer/Label

var loading: bool = false

func _ready() -> void:
	create_tween().tween_property(label, "modulate:a", 1.0, 1.0)

func _input(event: InputEvent) -> void:
	if loading: return
	if event is InputEventJoypadButton or event is InputEventMouseButton or event is InputEventKey:
		change_to_game()

func change_to_game() -> void:
	loading = true
	explosion.play()
	texture_rect.texture = EXPLOD
	
	
	var tween = create_tween()
	tween.tween_property(texture_rect, "modulate", Color.WHITE, 1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(texture_rect, "modulate", Color("7f7f7f"), 0.5)
	
	shake_screen(25, 3)
	
	await get_tree().create_timer(3.0).timeout
	Global.load_to("res://scenes/room_generation/map.tscn")

func shake_screen(amp: float, duration: float) -> void:
	var starting_pos: Vector2 = texture_rect.position
	
	var timer = get_tree().create_timer(duration)
	while timer.time_left > 0.0:
		amp = amp * timer.time_left/duration
		texture_rect.position = starting_pos + Vector2(randf_range(-amp, amp), randf_range(-amp, amp))
		
		if is_inside_tree():
			await get_tree().create_timer(0.05).timeout
		
	texture_rect.position = starting_pos

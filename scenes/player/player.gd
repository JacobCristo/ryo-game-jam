class_name Player extends CharacterBody2D

@onready var music_bus_index = AudioServer.get_bus_index("Music")
@onready var low_pass_filter = AudioServer.get_bus_effect(music_bus_index, 0)

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var health: float = 100.0

func _physics_process(_delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func take_damage(damage: float) -> void:
	health -= damage
	apply_damage_effect()
	
	if health <= 0:
		die()
		
func die() -> void:
	queue_free()
	print("you died loser")

func apply_damage_effect():
	# muffle the music over 0.5s
	create_tween().tween_property(low_pass_filter, "cutoff_hz", 250, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	# wait 1s then tweek back to normal 
	await get_tree().create_timer(1.0).timeout
	create_tween().tween_callback(_restore_music)

func _restore_music():
	create_tween().tween_property(low_pass_filter, "cutoff_hz", 2000, 1).set_ease(Tween.EASE_IN)

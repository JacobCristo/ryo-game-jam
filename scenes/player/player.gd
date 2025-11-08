class_name Player extends CharacterBody2D

@onready var music_bus_index = AudioServer.get_bus_index("Music")
@onready var low_pass_filter = AudioServer.get_bus_effect(music_bus_index, 0)

const SPEED = 600.0
const JUMP_VELOCITY = -400.0

var dash_scalar: float = 200.0
var dash_length: float = 0.1
var health: float = 100.0

#TODO 	Dash Cooldown Timer 


func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("move_left","move_right","move_up","move_down")
	print(direction)
	velocity = direction * SPEED
	move_and_slide()
	
	if (Input.is_action_pressed("dash")):
		dash(direction)

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
	
	

func dash(dir: Vector2) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(global_position + (dir * dash_scalar)), dash_length)
	pass
	
	
	
	

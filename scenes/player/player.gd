class_name Player extends CharacterBody2D

@onready var music_bus_index = AudioServer.get_bus_index("Music")
@onready var low_pass_filter = AudioServer.get_bus_effect(music_bus_index, 0)
@onready var flash_animation : AnimationPlayer = %FlashAnimation

@export_group("Dash Stats")
@export var dash_cooldown: float = 1.0#s
@export var dash_scalar: float = 2500.0
@export var dash_length: float = 0.1

@export_group("Player Stats")
@export var speed: float = 600.0
@export var strength: float = 20.0
@export var max_health: float = 100.0

var health: float = max_health

var dash_timer: float = 0.0
var is_dashing: float = false #bro so ugly

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if not is_dashing:
		velocity = direction * speed
	
	move_and_slide()
	
	dash_timer = max(dash_timer - delta, 0.0)
	if Input.is_action_pressed("dash") and dash_timer == 0.0:
		start_dash(direction)
		dash_timer = dash_cooldown
		
		flash_animation.play("dash")
	

func start_dash(dir: Vector2) -> void:
	if dir == Vector2.ZERO:
		return
	is_dashing = true
	velocity = dir.normalized() * dash_scalar
	await get_tree().create_timer(dash_length).timeout
	is_dashing = false

func take_damage(damage: float) -> void:
	if is_dashing:
		return
	
	health -= damage
	apply_damage_effect()
	Global.shake_camera(damage, 0.25)
	Global.playerHit.emit(damage, health)
	
	if health <= 0:
		die()
		
func die() -> void:
	queue_free()
	print("you died loser")

func apply_damage_effect():
	# muffle the music over 0.5s
	create_tween().tween_property(low_pass_filter, "cutoff_hz", 250, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	var processing = get_tree().get_first_node_in_group("shaders") as PostProcessing
	processing.tween_fisheye(0.25, 1.4)
	processing.tween_sobel(1.0)
	
	# wait 1s then tweek back to normal 
	await get_tree().create_timer(1.0).timeout
	create_tween().tween_callback(_restore_music)

func _restore_music():
	create_tween().tween_property(low_pass_filter, "cutoff_hz", 20500, 1).set_ease(Tween.EASE_IN)

func dash(dir: Vector2) -> void:
	if dir == Vector2.ZERO:
		return

	velocity = dir.normalized() * dash_scalar
	move_and_slide()
	
	# brief dash duration
	await get_tree().create_timer(dash_length).timeout
	velocity = Vector2.ZERO

func increase_stat(stat_name: String, increase: float) -> void:
	match stat_name.to_lower():
		"health":
			var temp_health = max_health
			max_health *= increase
			health += max_health - temp_health
		"speed":
			speed *= increase
		"strength":
			strength *= increase

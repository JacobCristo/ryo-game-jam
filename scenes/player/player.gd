class_name Player extends CharacterBody2D

const INVINCIBLE_COOLDOWN_MAX: float = 1.0

@onready var flash_animation: AnimationPlayer = %FlashAnimation
@onready var music_bus_index = AudioServer.get_bus_index("Music")
@onready var low_pass_filter = AudioServer.get_bus_effect(music_bus_index, 0)

@export_group("Dash Stats")
@export var dash_cooldown: float = 1.0 # seconds
@export var dash_scalar: float = 2500.0
@export var dash_length: float = 0.1

@export_group("Player Stats")
@export var speed: float = 600.0
@export var strength: float = 20.0
@export var max_health: float = 100.0
@export var max_goop: float = 100.0

var _invincible_cool_down: float
var _is_invincible: bool

var health: float = max_health:
	set(value):
		value = clamp(value, 0, max_health)
		var playerui = get_tree().get_first_node_in_group("playerui") as PlayerUI
		if playerui:
			playerui.change_health(max_health, value)
		health = value

var goop: float = max_goop:
	set(value):
		value = clamp(value, 0, max_goop)
		var playerui = get_tree().get_first_node_in_group("playerui") as PlayerUI
		if playerui:
			playerui.change_goop(max_goop, value)
		goop = value

var dash_timer: float = 0.0
var is_dashing: bool = false

func _process(delta: float) -> void:
	if(_is_invincible) :
		_invincible_cool_down -= delta
		
		if(_invincible_cool_down <= 0) :
			_is_invincible = false

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if not is_dashing:
		velocity = direction * speed

	move_and_slide()

	dash_timer = max(dash_timer - delta, 0.0)
	if Input.is_action_pressed("dash") and dash_timer == 0.0:
		start_dash(direction)
		dash_timer = dash_cooldown

func start_dash(dir: Vector2) -> void:
	if dir == Vector2.ZERO:
		return
	is_dashing = true
	velocity = dir.normalized() * dash_scalar
	await get_tree().create_timer(dash_length).timeout
	is_dashing = false

func take_damage(damage: float) -> void:
	if _is_invincible:
		return
	if is_dashing:
		return
		
	flash_animation.play("flash")

	health -= damage
	apply_damage_effect()
	Global.shake_camera(damage, 0.25)
	Global.playerHit.emit(damage, health)
	
	_invincible_cool_down = INVINCIBLE_COOLDOWN_MAX
	_is_invincible = true

	if health <= 0:
		die()

func die() -> void:
	queue_free()
	print("You died, loser.")

func apply_damage_effect():
	# muffle the music over 0.5s
	create_tween().tween_property(low_pass_filter, "cutoff_hz", 250, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	var processing = get_tree().get_first_node_in_group("shaders") as PostProcessing
	if processing:
		processing.tween_fisheye(0.25, 1.4)
		processing.tween_sobel(1.0)

	# wait 1s then restore music
	await get_tree().create_timer(1.0).timeout
	create_tween().tween_callback(_restore_music)

func _restore_music():
	create_tween().tween_property(low_pass_filter, "cutoff_hz", 20500, 1).set_ease(Tween.EASE_IN)

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

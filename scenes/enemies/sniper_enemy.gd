class_name SniperEnemy extends Enemy

const SNIPER_PROJECTILE = preload("uid://dxvheu50y385i")

@onready var laser: ColorRect = $Laser

var is_knocked_back: bool = false
var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_duration: float = 0.25
var knockback_timer: float = 0.0

func _ready() -> void:
	health = max_health
	sightline.target_position.x = sightline_range
	
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")
	

func _active_physics_process(delta: float) -> void:
	if not player:
		return
	
	if is_knocked_back:
		velocity = knockback_velocity
		move_and_slide()
		
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			is_knocked_back = false
			knockback_velocity = Vector2.ZERO
		return
	
	sightline.look_at(player.global_position)
	
	if fire_cooldown != 0.0:
		fire_cooldown = maxf(fire_cooldown - delta, 0.0)
	
	var ray_collisions = sightline.get_collider()
	if ray_collisions and ray_collisions is Player:
		if fire_cooldown == 0.0:
			fire_cooldown = fire_rate
			charge_shot(player.global_position)
		return
	
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed * delta
	move_and_slide()


func charge_shot(target_pos: Vector2) -> void:
	var charge_time: float = 1.0

	laser.rotation = (target_pos - global_position).angle()
	create_tween().tween_property(laser, "color", Color.RED, charge_time)
	
	await get_tree().create_timer(charge_time).timeout
	shoot(target_pos)

func shoot(target_pos: Vector2) -> void:
	var projectile = SNIPER_PROJECTILE.instantiate() as Projectile
	projectile.global_position = global_position
	projectile.direction = (target_pos - global_position).normalized()
	get_tree().current_scene.call_deferred("add_child", projectile)
	
	# fade out laser
	create_tween().tween_property(laser, "color:a", 0.0, 0.1)
	
	# apply knockback away from shot direction
	apply_blowback(target_pos)

func apply_blowback(target_pos: Vector2) -> void:
	var blow_dir: Vector2 = (global_position - target_pos).normalized()
	is_knocked_back = true
	knockback_timer = knockback_duration
	
	# Start velocity
	knockback_velocity = blow_dir * 800.0  # tweak this for strength
	
	# Smoothly reduce knockback velocity to 0
	var tween = create_tween()
	tween.tween_method(
		func(v): knockback_velocity = blow_dir * v,
		800.0, 0.0,
		knockback_duration
	).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func take_damage(amount: float) -> void:
	super.take_damage(amount)

func die() -> void:
	super.die()

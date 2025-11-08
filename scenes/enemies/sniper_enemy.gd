class_name SniperEnemy extends Enemy

const SNIPER_PROJECTILE = preload("uid://dxvheu50y385i")

@onready var laser: ColorRect = $Laser

func _ready() -> void:
	health = max_health
	# set raycast length to sightline range
	sightline.target_position.x = sightline_range
	
	# find player within the scene
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if not player:
		return
	
	# look for player
	sightline.look_at(player.global_position)
	
	if fire_cooldown != 0.0:
		fire_cooldown = maxf(fire_cooldown - delta, 0.0)
	
	# if player in range, shoot at player provided we can
	var ray_collisions = sightline.get_collider()
	if ray_collisions and ray_collisions is Player:
		if fire_cooldown == 0.0:
			# reset fire cooldown
			fire_cooldown = fire_rate
			charge_shot(player.global_position)
		
		# return so you don't move when in range of the player
		return
	
	# if player not in range, move towards player
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
	projectile.direction = Vector2(target_pos - global_position)
	
	get_tree().current_scene.call_deferred("add_child", projectile)
	
	# tween laser to transparent
	create_tween().tween_property(laser, "color:a", 0.0, 0.1)
	
	# blow backwards away from shot direction
	var blowback: Vector2 = global_position + (global_position - target_pos).normalized() * 200
	create_tween().tween_property(self, "global_position", blowback , 0.25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func take_damage(amount: float) -> void:
	health -= amount
	if health <= 0 and not dead:
		die()

func die() -> void:
	died.emit(self)
	dead = true
	queue_free()

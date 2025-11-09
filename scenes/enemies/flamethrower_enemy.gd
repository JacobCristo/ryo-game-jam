class_name FlamethrowerEnemy extends Enemy

const FIRE_PROJECTILE = preload("uid://v83wjkjo57e5")
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

func _ready() -> void:
	
	health = max_health
	# set raycast length to sightline range
	sightline.target_position.x = sightline_range
	
	# find player within the scene
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")

func _active_physics_process(delta: float) -> void:
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
			sprite_2d.play("shoot") 
			shoot(player.global_position)
		
		# return so you don't move when in range of the player
		return
	
	# if player not in range, move towards player
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed * delta
	if(not sprite_2d.is_playing()) :
		sprite_2d.play("moving")
	move_and_slide()
	
func shoot(target_pos: Vector2) -> void:
	$AudioStreamPlayer2D.play()
	var total_projectiles := 25
	
	var base_spread := TAU / 12 # total cone angle: 30 deg
	var half_spread := base_spread / 2

	for i in total_projectiles:
		var projectile = FIRE_PROJECTILE.instantiate() as Projectile
		projectile.global_position = global_position
		
		var dir := (target_pos - global_position).normalized()
		var angle_offset := randf_range(-half_spread, half_spread)
		projectile.direction = dir.rotated(angle_offset)
		
		get_tree().current_scene.call_deferred("add_child", projectile)
		await get_tree().create_timer(0.05).timeout # wait before shooting next projectile

func take_damage(amount: float) -> void:
	sprite_2d.play("stunned")
	super.take_damage(amount)

func die() -> void:
	velocity = Vector2.ZERO
	
	# TODO: Play animation and on finish run delete methods
	sprite_2d.play("dead")
	died.emit(self)
	if(sprite_2d.animation == "dead"):
		await sprite_2d.animation_looped
		queue_free()

	
	
	

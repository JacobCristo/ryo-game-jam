class_name MeleeEnemy extends Enemy

@onready var punch_area: Area2D = $PunchArea
@onready var punchSound : AudioStreamPlayer = %Punch

@export var damage: float = 5.0
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

func _ready() -> void:
	health = max_health
	# set raycast length to sightline range
	sightline.target_position.x = sightline_range
	fire_rate = 1
	
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
			charge_punch(player.global_position)
		
		# return so you don't move when in range of the player
		return
	
	# if player not in range, move towards player
	var direction = (player.global_position - global_position).normalized()
	if(direction.x < 0) :
		sprite_2d.flip_h = true
	else :
		sprite_2d.flip_h = false
	velocity = direction * speed * delta
	if(not sprite_2d.is_playing() or not sprite_2d.animation == "walk") :
		sprite_2d.play("walk")
	move_and_slide()

func punch() -> void:
	punchSound.play()
	for body in punch_area.get_overlapping_bodies():
		if body is Player:
			player = body as Player
			player.take_damage(damage)
	
	# reset fire cooldown
	fire_cooldown = fire_rate

func charge_punch(target_pos: Vector2) -> void:
	sprite_2d.play("punch")
	punch_area.rotation = (target_pos - global_position).angle()
	
	#var tween = create_tween()
	#tween.tween_property($PunchArea/AreaHighlight, "size:x", 200.0, 0.5)
	#await tween.finished
		
	await get_tree().create_timer(0.5).timeout
	punch()
	
	#$PunchArea/AreaHighlight.size.x = 16.0
	
func take_damage(amount: float) -> void:
	sprite_2d.play("hit")
	super.take_damage(amount)

func die() -> void:
	velocity = Vector2.ZERO
	
	# TODO: Play animation and on finish run delete methods
	sprite_2d.play("die")
	died.emit(self)
	if(sprite_2d.animation == "die"):
		await sprite_2d.animation_looped
		queue_free()
	

class_name MeleeEnemy extends Enemy

@onready var punch_area: Area2D = $PunchArea

@export var damage: float = 5.0

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
			charge_punch(player.global_position)
		
		# return so you don't move when in range of the player
		return
	
	# if player not in range, move towards player
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed * delta
	move_and_slide()

func punch() -> void:
	for body in punch_area.get_overlapping_bodies():
		if body is Player:
			player = body as Player
			player.take_damage(damage)
	
	# reset fire cooldown
	fire_cooldown = fire_rate

func charge_punch(target_pos: Vector2) -> void:
	punch_area.rotation = (target_pos - global_position).angle()
	
	var tween = create_tween()
	tween.tween_property($PunchArea/AreaHighlight, "size:x", 200.0, 0.5)
	
	await tween.finished
	punch()
	
	$PunchArea/AreaHighlight.size.x = 16.0
	
func take_damage(amount: float) -> void:
	health -= amount
	if health <= 0 and not dead:
		die()

func die() -> void:
	died.emit(self)
	dead = true
	queue_free()

class_name Enemy extends CharacterBody2D 

signal died(enemy: Enemy)

const BASIC_PROJECTILE = preload("uid://cqtchbtdssh5n")
const STUNNED_COOLDOWN_MAX: float = 1.0
const END_DMG_MULT: float = 2.0
const VELOCITY_DMG_SCALER: float = 100.0


@export var speed: float = 5000.0
@export var stunned_speed: float = 30000.0
@export var stunned_speed_falloff: float = 500.0
@export var max_health: float = 25.0

@export_group("Firing Stats")
@export var sightline_range: float = 250.0
@export var fire_rate: float = 0.25
@export var fire_cooldown: float = 0.0

@onready var player: CharacterBody2D = null
@onready var sightline: RayCast2D = $Sightline
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer

var health: float
var stunned_cool_down: float
var state: EnemyState
var _stunned_dir: Vector2
var _just_stunned: bool

enum EnemyState {
	ACTIVE,
	STUNNED,
	DEAD
}

func _ready() -> void:
	health = max_health
	_stunned_dir = Vector2.ZERO
	stunned_cool_down = STUNNED_COOLDOWN_MAX
	_just_stunned = false
	
	# set raycast length to sightline range
	sightline.target_position.x = sightline_range
	
	# set starting state
	# TODO: create alert state
	state = EnemyState.ACTIVE
	
	# find player within the scene
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")
	
func _process(delta: float) -> void:
	_determine_correct_animation()
	if not player:
		return
	
	if(state == EnemyState.STUNNED) :
		modulate = Color.DIM_GRAY
		stunned_cool_down -= delta
		if(stunned_cool_down <= 0) :
			state = EnemyState.ACTIVE
			stunned_cool_down = STUNNED_COOLDOWN_MAX
			velocity = Vector2.ZERO
			
	if(state == EnemyState.ACTIVE) :
		modulate = Color.WHITE
			
			
		
func _physics_process(delta: float) -> void:
	if(state == EnemyState.ACTIVE):
		_active_physics_process(delta)
	if(state == EnemyState.STUNNED):
		_stunned_physics_process(delta)
		
func _stunned_physics_process(delta: float) -> void:
	if(_just_stunned) :
		velocity = _stunned_dir * stunned_speed * delta
		_just_stunned = false
	else :
		velocity = velocity.move_toward(Vector2.ZERO, stunned_speed_falloff * delta)
		move_and_slide()
	
	
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
			shoot(player.global_position)
		
		# return so you don't move when in range of the player
		return
	
	# if player not in range, move towards player
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed * delta
	move_and_slide()

func shoot(target_pos: Vector2) -> void:
	var projectile = BASIC_PROJECTILE.instantiate() as Projectile
	
	projectile.global_position = global_position
	projectile.direction = Vector2(target_pos - global_position)
	
	get_tree().current_scene.call_deferred("add_child", projectile)

func take_damage(amount: float) -> void:
	health -= amount
	audio.play()
	if health <= 0 and not state == EnemyState.DEAD:
		state = EnemyState.DEAD
		die()

func die() -> void:
	velocity = Vector2.ZERO
	
	# TODO: Play animation and on finish run delete methods
	
	died.emit(self)
	queue_free()
	
func _determine_correct_animation() :
	if(state == EnemyState.ACTIVE) :
		# TODO: change animation controller
		# to switch to repeated active animation
		pass
	if(state == EnemyState.STUNNED) :
		# TODO: change animation controller
		# to switch to repeated stunned animation
		pass
	

func _on_hitbox_body_entered(body: Node2D) -> void:
	# if stunned return
	if(state == EnemyState.STUNNED or state == EnemyState.DEAD) :
		return
	
	if(body is Segment or body is TentacleEnd) :
		state = EnemyState.STUNNED 
			
		var _dmg_amt: float = 0.0
		if(body is Segment) :
			body = body as Segment
			_dmg_amt = _calc_dmg_amt_segment(body)
		
		if(body is TentacleEnd) :
			body = body as TentacleEnd
			_dmg_amt = _calc_dmg_amt_end(body)
		
		# Take damage
		take_damage(_dmg_amt)
		
		# Calculate stun direction
		var r_body = body
		if(r_body is RigidBody2D) :
			_stunned_dir = r_body.linear_velocity.normalized()
			_just_stunned = true
	
	
func _calc_dmg_amt_segment(body: Node2D) -> float:
	var dmg_amt: float = 0.0
	
	var r_body = body
	if(r_body is RigidBody2D) :
		dmg_amt = r_body.linear_velocity.length() / VELOCITY_DMG_SCALER
	
	return dmg_amt
	
func _calc_dmg_amt_end(body: Node2D) -> float:
	var dmg_amt: float = 0.0
	
	var r_body = body
	if(r_body is RigidBody2D) :
		dmg_amt = (r_body.linear_velocity.length() / VELOCITY_DMG_SCALER) * END_DMG_MULT
	
	return dmg_amt

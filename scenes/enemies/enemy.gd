class_name Enemy extends CharacterBody2D 

signal died(enemy: Enemy)

const BASIC_PROJECTILE = preload("uid://cqtchbtdssh5n")
const STUNNED_COOLDOWN_MAX: float = 1.0
const END_DMG_MULT: float = 2.0
const VELOCITY_DMG_SCALER: float = 100.0

@export var speed: float = 5000.0
@export var stunned_speed: float = 5000.0
@export var max_health: float = 25.0

@export_group("Firing Stats")
@export var sightline_range: float = 250.0
@export var fire_rate: float = 0.25
@export var fire_cooldown: float = 0.0

@onready var player: CharacterBody2D = null
@onready var sightline: RayCast2D = $Sightline

var health: float
var stunned_cool_down: float
var state: EnemyState
var stunned_dir: Vector2

enum EnemyState {
	ACTIVE,
	STUNNED,
	DEAD
}

func _ready() -> void:
	health = max_health
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
		stunned_cool_down -= delta
		if(stunned_cool_down <= 0) :
			state = EnemyState.ACTIVE
			stunned_cool_down = STUNNED_COOLDOWN_MAX
			
			
		
func _physics_process(delta: float) -> void:
	if(state == EnemyState.ACTIVE):
		_active_physics_process(delta)
	if(state == EnemyState.STUNNED):
		_stunned_physics_process(delta)
		
func _stunned_physics_process(delta: float) -> void:
	velocity = stunned_dir * stunned_speed * delta
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
	if(state == EnemyState.STUNNED) :
		return 
		
	# if body is Tentacle or whatever:
		# take_damage(x amount of damage)
		# if health is 0 activate die
		# might cause issues with reading in class
	var _dmg_amt: float = 0.0
	if(body is Segment) :
		
		pass
	
	if(body is TentacleEnd) :
		pass
	# Take damage
	# Apply force
	# Change state
	# Change sprite
	pass
	
func _calc_dmg_amt_segment(body: Node2D) -> float:
	var dmg_amt: float = 0.0
	body = body as Segment
	
	var r_body = body.get_parent()
	if(r_body is RigidBody2D) :
		dmg_amt = r_body.linear_velocity
	
	return dmg_amt
	
func _calc_dmg_amt_end(body: Node2D) -> float:
	var dmg_amt: float = 0.0
	body = body as TentacleEnd
	
	return dmg_amt
	

	
	

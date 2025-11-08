class_name Enemy extends CharacterBody2D 

signal died(enemy: Enemy)

const BASIC_PROJECTILE = preload("uid://cqtchbtdssh5n")

@export var speed: float = 5000.0
@export var max_health: float = 25.0

@export_group("Firing Stats")
@export var sightline_range: float = 250.0
@export var fire_rate: float = 0.25
@export var fire_cooldown: float = 0.0

@onready var player: CharacterBody2D = null
@onready var sightline: RayCast2D = $Sightline

var health: float
var dead: bool = false

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
			shoot(player.global_position)
		
		# return so you don't move when in range of the player
		return
	
	# if player not in range, move towards player
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed * delta
	move_and_slide()

func shoot(target_pos: Vector2) -> void:
	var projectile = BASIC_PROJECTILE.instantiate() as BasicProjectile
	
	projectile.global_position = global_position
	projectile.direction = Vector2(target_pos - global_position)
	
	get_tree().current_scene.call_deferred("add_child", projectile)
	
	# reset fire cooldown
	fire_cooldown = fire_rate


func take_damage(amount: float) -> void:
	health -= amount
	if health <= 0 and not dead:
		die()

func die() -> void:
	died.emit(self)
	dead = true
	queue_free()

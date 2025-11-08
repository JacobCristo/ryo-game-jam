class_name Enemy extends CharacterBody2D 

signal died(enemy: Enemy)

const PROJECTILE = preload("uid://dgkm4cwej18fm")

@export var speed: float = 5000.0
@export var max_health: float = 25.0

@onready var player: CharacterBody2D = null
@onready var sightline: RayCast2D = $Sightline

var health: float
var dead: bool = false

func _ready() -> void:
	health = max_health
	
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")

func _process(_delta: float) -> void:
	# find the player 
	if player: sightline.look_at(player.global_position)
	
	var ray_collisions = sightline.get_collider()
	if ray_collisions and ray_collisions is Player:
		shoot(player.global_position)

func _physics_process(delta: float) -> void:
	if not player:
		return
	
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed * delta
	move_and_slide()

func shoot(target_pos: Vector2) -> void:
	var projectile = PROJECTILE.instantiate()
	projectile.direction = Vector2(target_pos - global_position)

func take_damage(amount: float) -> void:
	health -= amount
	if health <= 0 and not dead:
		die()

func die() -> void:
	died.emit(self)
	dead = true
	queue_free()

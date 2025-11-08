class_name Player extends CharacterBody2D

const SPEED = 600.0
const JUMP_VELOCITY = -400.0

var dash_scalar: float = 200.0
var dash_length: float = 0.1
var health: float = 100.0

#TODO 	Dash Cooldown Timer 


func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("move_left","move_right","move_up","move_down")
	print(direction)
	velocity = direction * SPEED
	move_and_slide()
	
	if (Input.is_action_pressed("dash")):
		dash(direction)

func take_damage(damage: float) -> void:
	health -= damage
	if health <= 0:
		die()
		
func die() -> void:
	queue_free()
	print("you died loser")
	
	

func dash(dir: Vector2) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(global_position + (dir * dash_scalar)), dash_length)
	pass
	
	
	
	

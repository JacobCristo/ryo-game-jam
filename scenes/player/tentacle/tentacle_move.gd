class_name TentacleEnd extends Node2D

# TODO: Test script
@onready var _r_body: RigidBody2D = %End
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var tentacle_base: StaticBody2D = %TentacleBase
@onready var tentacle: Node2D = $"../.."

var all_rigidbodies: Array[Node]

var _input_dir
var _force : Vector2

const DEADZONE = 0.1
const FORCE_AMT = 20000.0
const IMPULSE_AMT = 50000.0

# TODO: Set up thing to change this when actually using MKB
var mouse_control = false

# to fix tentacle stretch glitch
var base_to_end = 0.0
var stretch_give = 100.0
var is_overstretched = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_input_dir = Vector2.ZERO
	
	base_to_end = tentacle_base.global_position.distance_to(_r_body.global_position)
	
	all_rigidbodies = tentacle.find_children("*", "RigidBody2D", true, false)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_read_input()
	
func _physics_process(delta: float) -> void:
	if(Input.is_action_pressed("boost_chain") and get_tree().get_first_node_in_group("player").goop > 0) :
		_apply_impulse_to_chain(delta)
		get_tree().get_first_node_in_group("player").goop -= 0.5
		
	else :
		get_tree().get_first_node_in_group("player").goop += 0.03
		_apply_force_to_chain(delta)
		
	# TODO: 
	#if(Input.is_action_just_released("boost_chain")) :
	#	var opposite = Vector2(-1 * _input_dir)
	#	_r_body.apply_central_impulse(opposite * (IMPULSE_AMT / 2))
		
	# test for tentacle overstretching
	var stretch_distance_squared = tentacle_base.global_position.distance_squared_to(_r_body.global_position)
	
	if (stretch_distance_squared > pow(base_to_end + stretch_give, 2)) :
		print("overstretch")
		is_overstretched = true
		
		for rb : RigidBody2D in all_rigidbodies :
			#rb.collision_mask
			print("test")
		
	elif (is_overstretched) :
		print("stretch fixed")
		is_overstretched = false
		
	
func _read_input() -> void:
	# Read input and register to unit vector variable
	
	if mouse_control:
		var mouse_pos = get_viewport().get_mouse_position()
		var screen_center = get_viewport_rect().size / 2;
		_input_dir = (mouse_pos - screen_center).normalized()
	else:
		_input_dir = Input.get_vector(
			"move_chain_left", 
			"move_chain_right", 
			"move_chain_up", 
			"move_chain_down",
			DEADZONE).normalized()
	
	
func _apply_force_to_chain(delta) -> void:
	# Multiply direction by FORCE_AMT
	_force = _input_dir * FORCE_AMT * delta
	_r_body.apply_central_force(_force)
	
func _apply_impulse_to_chain(delta) -> void:
	# Multiply direction by IMPULSE_AMT
	# Used when boosting
	_force = _input_dir * IMPULSE_AMT * delta
	_r_body.apply_central_impulse(_force)
	
func disable() -> void:
	collision.set_deferred("disabled", true)
	
func enable() -> void:
	collision.set_deferred("disabled", false)

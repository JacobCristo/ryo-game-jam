extends Node

# TODO: Test script
@onready var _r_body: RigidBody2D = %End

var _input_dir
var _force

const DEADZONE = 0.1
const FORCE_AMT = 10000.0
const IMPULSE_AMT = 5000.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_input_dir = Vector2.ZERO
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_read_input()
	
func _physics_process(delta: float) -> void:
	if(Input.is_action_pressed("boost_chain")) :
		# TODO: Check for boost meter when implemented
		_apply_impulse_to_chain(delta)
	else :
		_apply_force_to_chain(delta)
		
	# TODO: 
	#if(Input.is_action_just_released("boost_chain")) :
	#	var opposite = Vector2(-1 * _input_dir)
	#	_r_body.apply_central_impulse(opposite * (IMPULSE_AMT / 2))
		
		
	
func _read_input() -> void:
	# Read input and register to unit vector variable
	_input_dir = Input.get_vector(
		"move_chain_left", 
		"move_chain_right", 
		"move_chain_up", 
		"move_chain_down",
		DEADZONE).normalized()
	
func _apply_force_to_chain(delta) -> void:
	# Multiply direction by FORCE_AMT
	_force = _input_dir * FORCE_AMT * delta
	print(_force)
	_r_body.apply_central_force(_force)
	
func _apply_impulse_to_chain(delta) -> void:
	# Multiply direction by IMPULSE_AMT
	# Used when boosting
	_force = _input_dir * IMPULSE_AMT * delta
	print(_force)
	_r_body.apply_central_impulse(_force)
	
	

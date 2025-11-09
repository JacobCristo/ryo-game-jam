class_name TentacleEnd extends Node2D

# TODO: Test script
@onready var _r_body: RigidBody2D = %End
@onready var collision: CollisionShape2D = $CollisionShape2D

var _input_dir
var _force : Vector2

const DEADZONE = 0.1
const FORCE_AMT = 20000.0
const IMPULSE_AMT = 50000.0

# TODO: Set up thing to change this when actually using MKB
var mouse_control = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_input_dir = Vector2.ZERO
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_read_input()
	
func _physics_process(delta: float) -> void:
	if(Input.is_action_pressed("boost_chain")) :
		var player = get_tree().get_first_node_in_group("player")
		player.goop -= 0.5
		if player.goop > 0.0:
			_apply_impulse_to_chain(delta)
		
	else :
		get_tree().get_first_node_in_group("player").goop += 0.03
		_apply_force_to_chain(delta)
		
	# TODO: 
	#if(Input.is_action_just_released("boost_chain")) :
	#	var opposite = Vector2(-1 * _input_dir)
	#	_r_body.apply_central_impulse(opposite * (IMPULSE_AMT / 2))
		
		
	
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

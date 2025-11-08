extends Node

# TODO: Access rigidbody on the thing with CTRL + DRAG

var _input_dir
const DEADZONE = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_input_dir = Vector2.ZERO
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_read_input()
	_apply_force_to_chain()
	
	
func _read_input() -> void:
	# Read input and register to unit vector variable
	_input_dir = Input.get_vector(
		"move_chain_left", 
		"move_chain_right", 
		"move_chain_down", 
		"move_chain__",
		DEADZONE).normalized()
	
func _apply_force_to_chain() -> void:
	pass
	

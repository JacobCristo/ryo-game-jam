class_name Map extends Node2D

# the offset in both x and y directions between rooms
const ROOM_OFFSET = 3000

func _ready() -> void:
	# NOTE: assumes room_manager generates floor
	for node in Global.rooms.values(): 
		add_child(node)
		node.global_position = node.room_coordinate * ROOM_OFFSET
		
		

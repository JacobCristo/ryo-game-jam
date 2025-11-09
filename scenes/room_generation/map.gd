class_name Map extends Node2D

# the offset in both x and y directions between rooms
const ROOM_OFFSET = 3000

@onready var room_manager: RoomManager = $room_manager
@onready var player: Player = $Player

func _ready() -> void:
	for node: Room in Global.rooms.values(): 
		add_child(node)
		node.global_position = node.room_coordinate * ROOM_OFFSET
	
	var room: Room =  Global.rooms.values()[0]
	player.global_position = Vector2(room.door_coords[0]) + room.global_position

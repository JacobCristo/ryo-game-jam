class_name Room extends Node2D

const DOOR = preload("uid://wm1u28rq3c8x")

# array of coordinates of neighboring rooms
@export var neighbors = []
@export var enemies = []
@export var room_coordinate = null;

# top, left , right ,down
@export var door_coords: Array[Vector2i] = []

var doors = []

func _ready() -> void:
	for neighbor in neighbors:
		var door = DOOR.instantiate()
		
		if neighbor.x < room_coordinate.x:
			door.position = door_coords[1] # left
		if neighbor.x > room_coordinate.x:
			door.position = door_coords[2] # right
			
		if neighbor.y < room_coordinate.y:
			door.position = door_coords[1] # top 
		if neighbor.y > room_coordinate.y:
			door.position = door_coords[3] # bottom

func open_doors() -> void:
	for door in doors:
		door.open_door()
	

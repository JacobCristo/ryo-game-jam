class_name Room
extends Node2D

const DOOR = preload("uid://wm1u28rq3c8x")

# array of coordinates of neighboring rooms (Vector2i)
@export var neighbors = []
@export var enemies: Array[Enemy] = []
@export var room_coordinate = null

# top, left, down, right 
@export var door_coords: Array[Vector2i] = []

var doors = []

func _ready() -> void:
	# create doors for each neighbor coordinate
	for neighbor in neighbors:
		var door = DOOR.instantiate() as Door
		var door_index: int = _get_door_index_for_neighbor(neighbor)
		if door_index == -1:
			continue

		door.position = door_coords[door_index]
		add_child(door)

		var next_room: Room = Global.rooms[neighbor]
		var back_index: int = next_room._get_door_index_for_neighbor(room_coordinate)
		if back_index == -1:
			back_index = (door_index + 2) % 4

		await get_tree().process_frame
		door.next_door_coords = next_room.global_position + Vector2(next_room.door_coords[back_index])

		door.target_room_coord = neighbor
		door.target_back_index = back_index

		doors.append(door)
	
	# check enemies & connect signals safely
	check_for_enemies()
	for enemy in enemies:
		# bind the specific enemy to avoid closure capturing issues
		enemy.died.connect(_on_enemy_died.bind(enemy))
		
	for door in doors:
		var line = Line2D.new()
		line.width = 2
		line.default_color = Color.RED
		line.points = [door.position, Vector2(door.next_door_coords) - global_position]
		add_child(line)

func _get_door_index_for_neighbor(neighbor_coord: Vector2i) -> int:
	if neighbor_coord.y < room_coordinate.y:
		return 0 # top
	elif neighbor_coord.x < room_coordinate.x:
		return 1 # left
	elif neighbor_coord.y > room_coordinate.y:
		return 2 # bottom
	elif neighbor_coord.x > room_coordinate.x:
		return 3 # right
	return -1
	
func _on_enemy_died(enemy: Enemy) -> void:
	enemies.erase(enemy)
	check_for_enemies()

func open_doors() -> void:
	for door in doors:
		door.open_door()

func check_for_enemies() -> void:
	if enemies.size() == 0:
		open_doors()

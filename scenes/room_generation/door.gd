class_name Door extends Area2D

@export var next_door_coords: Vector2i = Vector2i.ZERO
@export var target_room_coord: Vector2i
@export var target_back_index: int

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var open: bool = false

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		teleport_player(body)

func teleport_player(player: CharacterBody2D) -> void:
	var target_room: Room = Global.rooms[target_room_coord]
	var target_door_pos: Vector2 = target_room.global_position + Vector2(target_room.door_coords[target_back_index])

	# offset the player away from the door, into the room
	var direction := Vector2.ZERO
	match target_back_index:
		0: direction = Vector2.DOWN
		1: direction = Vector2.RIGHT
		2: direction = Vector2.UP
		3: direction = Vector2.LEFT

	var offset_distance := 172.0
	var spawn_position := target_door_pos + direction * offset_distance

	player.global_position = spawn_position
	player.velocity = Vector2.ZERO
	
	Global.room_entered.emit()

func open_door() -> void:
	open = true
	sprite.play("open")

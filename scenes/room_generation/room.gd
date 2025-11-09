class_name Room extends Node2D

# array of coordinates of neighboring rooms
@export var neighbors = []
@export var enemies = []
@export var room_coordinate = null;
@export var doors = []

func open_doors() -> void:
	for door in doors:
		door.open_door()
	

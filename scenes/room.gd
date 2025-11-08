class_name Room extends Node2D

# Indices of each neighboring room in the neighbors Array
enum NeighborIndices {
	TOP,
	LEFT, 
	RIGHT,
	BOTTOM
}

@export var neighbors: Array[Room] = []

@export var enemies = []

func _ready() -> void:
	pass

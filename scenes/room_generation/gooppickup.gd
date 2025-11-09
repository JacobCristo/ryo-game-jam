extends Node2D

var player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")

func _on_area_2d_body_entered(_body: Node2D) -> void:
	player.goop += player.max_goop / 4
	queue_free()

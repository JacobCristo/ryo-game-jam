extends Node2D

var player: Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

func _on_area_2d_body_entered(_body: Node2D) -> void:
	player.goop += player.max_goop / 4
	queue_free()

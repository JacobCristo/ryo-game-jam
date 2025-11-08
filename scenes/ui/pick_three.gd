class_name PickThree extends MarginContainer

@onready var buttons: Array[Button] = [%FirstButton, %SecondButton, %ThirdButton]

var player: Player = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")

# health speed strength
func get_upgrades() -> void:
	
	pass

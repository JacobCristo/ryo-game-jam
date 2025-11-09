class_name PickThree extends MarginContainer
var player: Player = null
var choiceMade: bool = false

@onready var strengthButt : Button = %FirstButton
@onready var healthButt : Button = %SecondButton
@onready var speedButt : Button = %ThirdButton

func _ready() -> void:
	self.visible = false
	player = get_tree().get_first_node_in_group("player")
	strengthButt.pressed.connect(upgrade_chosen.bind("Strength"))
	healthButt.pressed.connect(upgrade_chosen.bind("Health"))
	speedButt.pressed.connect(upgrade_chosen.bind("Speed"))
	strengthButt.grab_focus()
	Global.connect("room_cleared", display)


func display() -> void:
	self.visible = true


func upgrade_chosen(upgrade: String):
	match(upgrade):
		"Health":
			player.increase_stat("health", 1.25)
			self.visible = false
		"Strength":
			player.increase_stat("strength", 1.20)
			self.visible = false
		"Speed":
			player.increase_stat("speed", 1.15)
			self.visible = false
			pass
	pass

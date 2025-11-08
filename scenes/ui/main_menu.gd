class_name MainMenu extends Control

const ROOM = preload("uid://nwhqrixlnb1d")

@onready var label: Label = $VBoxContainer/Label

func _ready() -> void:
	create_tween().tween_property(label, "modulate:a", 1.0, 1.0)

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventMouseButton or event is InputEventKey:
		get_tree().change_scene_to_packed(ROOM)

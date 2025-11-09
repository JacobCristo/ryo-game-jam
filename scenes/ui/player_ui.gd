class_name PlayerUI extends Control

@onready var health_bar: HealthBar = $MarginContainer/VBoxContainer/HBoxContainer/HealthBar
@onready var stamina_bar: StaminaBar = $MarginContainer/VBoxContainer/HBoxContainer/StaminaBar

func change_health(player_max_health: float, player_current_health: float) -> void:
	health_bar.max_value = player_max_health
	health_bar.health = player_current_health

func change_goop(player_max_goop: float, player_current_goop: float) -> void:
	stamina_bar.max_value = player_max_goop
	stamina_bar.goop = player_current_goop

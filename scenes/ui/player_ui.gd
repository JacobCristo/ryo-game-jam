class_name PlayerUI
extends Control

@export var time: float = 180.0 # 3 minutes in seconds

@onready var health_bar: HealthBar = $MarginContainer/VBoxContainer/HBoxContainer/HealthBar
@onready var stamina_bar: StaminaBar = $MarginContainer/VBoxContainer/HBoxContainer/StaminaBar
@onready var timer_label: Label = $MarginContainer/VBoxContainer/TimeLeft

var flashing := false
var scene_change_triggered := false

func change_health(player_max_health: float, player_current_health: float) -> void:
	health_bar.max_value = player_max_health
	health_bar.health = player_current_health

func change_goop(player_max_goop: float, player_current_goop: float) -> void:
	stamina_bar.max_value = player_max_goop
	stamina_bar.goop = player_current_goop

func _process(delta: float) -> void:
	if time > 0:
		time -= delta
	else:
		time = 0

	update_timer_display()

	if time < 60.0 and not flashing:
		start_timer_flash()

	if time <= 0.0 and not scene_change_triggered:
		scene_change_triggered = true
		# stop tweens to avoid conflict
		get_tree().create_timer(0.2).timeout.connect(_on_time_expired)

func _on_time_expired() -> void:
	if is_instance_valid(get_tree()):
		Global.load_to("res://scenes/ui/main_menu.tscn")

func update_timer_display() -> void:
	var minutes = int(time) / 60
	var seconds = int(time) % 60
	var milliseconds = int((time - int(time)) * 100)
	timer_label.text = "%02dm:%02ds:%02dms" % [minutes, seconds, milliseconds]

func start_timer_flash() -> void:
	flashing = true
	var tween = get_tree().create_tween()
	
	tween.set_loops(999999)
	tween.tween_property(timer_label, "modulate", Color.RED, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(timer_label, "modulate", Color.WHITE, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

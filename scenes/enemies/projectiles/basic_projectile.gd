class_name BasicProjectile extends Projectile
@onready var audio = $AudioStreamPlayer

func _ready() -> void:
	audio.play()
func _process(delta: float) -> void:
	move(delta)

## Progress towards direction at constant speed
func move(delta: float) -> void:
	position += direction.normalized() * speed * delta

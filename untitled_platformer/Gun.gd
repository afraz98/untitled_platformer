class_name Gun extends Marker2D

const BULLET_VELOCITY = 500.0
const Bullet = preload("res://Bullet.tscn")

func shoot(direction: float = 1.0) -> bool:
	if not $CooldownTimer.is_stopped():
		return false
	var bullet := Bullet.instantiate() as Bullet
	
	bullet.global_position = global_position
	bullet.linear_velocity = Vector2(direction * BULLET_VELOCITY, 0.0)

	bullet.set_as_top_level(true)
	add_child(bullet)
	
	$CooldownTimer.start()
	return true
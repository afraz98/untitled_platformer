class_name GrenadeThrower extends Marker2D

const Grenade = preload("res://Grenade.tscn")
const GRENADE_X_VELOCITY = 200.0
const GRENADE_Y_VELOCITY = 400.0

func throw_grenade(direction) -> bool:
	if !$ThrowTimer.is_stopped():
		return false

	var grenade := Grenade.instantiate() as Grenade
	grenade.global_position = global_position
	grenade.linear_velocity = Vector2(direction * GRENADE_X_VELOCITY, -GRENADE_Y_VELOCITY)
	grenade.scale.x = direction
	grenade.play_animation("throw")
	grenade.set_as_top_level(true)
	add_child(grenade)

	$ThrowTimer.start()
	return true

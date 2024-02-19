class_name Gun extends Marker2D

const Bullet = preload("res://Bullet.tscn")
const BULLET_VELOCITY = 500.0

# Maximum ammo capacity for the pistol
const PISTOL_MAGANIZE_CAPACITY = 10
var ammo := 0

func _ready():
	ammo = PISTOL_MAGANIZE_CAPACITY
	pass

func reload() -> bool:
	if not $ReloadTimer.is_stopped():
		# In the middle of a reload already -- cannot reload.
		return false
	$ReloadTimer.start()
	ammo = PISTOL_MAGANIZE_CAPACITY
	return true

func shoot(direction: float) -> bool:
	if ammo == 0:
		# TODO: Probably best to play some form of sound effect
		# indicating the player is out of ammo.
		return false
	
	if not $CooldownTimer.is_stopped():
		# Already shooting -- wait for cooldown to elapse.
		return false
		
	if not $ReloadTimer.is_stopped():
		# In the middle of reloading -- should not be able to shoot.
		return false
	
	var bullet := Bullet.instantiate() as Bullet
		
	bullet.global_position = global_position
	bullet.linear_velocity = Vector2(direction * BULLET_VELOCITY, 0.0)
	
	bullet.set_as_top_level(true)
	add_child(bullet)
	
	# Decrease current ammo
	ammo -= 1
	
	$CooldownTimer.start()
	return true

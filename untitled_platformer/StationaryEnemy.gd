class_name StationaryEnemy extends Enemy

# Called when the node enters the scene tree for the first time.
func _ready():
	walking_direction = -1.0
	# velocity.x = -WALK_MAX_SPEED
	pass

func get_new_animation():
	return "idle"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_animation_player.play(get_new_animation())

	if is_on_wall():
		velocity.x = -velocity.x
	
	# Flip sprite if moving left		
	if velocity.x != 0:
		$StationaryEnemySprite.flip_h = velocity.x > 0

	# Clamp to the maximum horizontal movement speed.
	# velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)

	# Vertical movement code. Apply gravity.
	velocity.y += gravity * delta

	# Move based on the velocity and snap to the ground.
	move_and_slide()
	pass

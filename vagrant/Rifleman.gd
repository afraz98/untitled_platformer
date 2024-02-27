class_name Rifleman extends Enemy

var is_standing: bool = false

func get_new_animation():
	if _state == STATE.IDLE:
		return "idle"
	elif _state == STATE.FIRING: 
		if !is_standing:
			$Timer.start()
			return "stand"
		return "shoot"
	return "death"

# Called when the node enters the scene tree for the first time.
func _ready():
	walking_direction = -1.0
	_state = STATE.IDLE
	pass

func check_player_proximity():
	if _state != STATE.DEAD:
		if(self.position.x - player_position) <= 50:
			_state = STATE.FIRING
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_on_wall():
		velocity.x = -velocity.x
	
	# Flip sprite if moving left		
	if velocity.x != 0:
		$StationaryEnemySprite.flip_h = velocity.x > 0

	# Clamp to the maximum horizontal movement speed.
	velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)

	# Vertical movement code. Apply gravity.
	velocity.y += gravity * delta

	# Move based on the velocity and snap to the ground.
	move_and_slide()
	
	# Handle player proximity	
	check_player_proximity()
	
	if _state == STATE.FIRING:
		if $Timer.is_stopped():
			is_standing = true

	var animation = get_new_animation()
	if animation != _animation_player.current_animation:
		_animation_player.play(animation)
	pass

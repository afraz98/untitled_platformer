class_name StationaryEnemy extends Enemy

func get_new_animation():
	if _state == STATE.IDLE:
		return "idle"
	if _state == STATE.FLEEING:
		return "flee"
	if _state == STATE.FEAR:
		return "fear"
	return "death"

func _enemy_died_nearby(enemy: Enemy):
	if !self.is_dead() and _state < STATE.FEAR:
		_state = STATE.FEAR
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	walking_direction = -1.0
	_state = STATE.IDLE
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if is_on_wall():
		velocity.x = -velocity.x
	
	# Flip sprite if moving left		
	if velocity.x != 0:
		$StationaryEnemySprite.flip_h = velocity.x > 0

	if _state == STATE.FLEEING:
		velocity.x = WALK_MAX_SPEED

	# Clamp to the maximum horizontal movement speed.
	velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)

	# Vertical movement code. Apply gravity.
	velocity.y += gravity * delta

	# Move based on the velocity and snap to the ground.
	move_and_slide()

	var animation = get_new_animation()
	if animation != _animation_player.current_animation:
		_animation_player.play(animation)
	pass

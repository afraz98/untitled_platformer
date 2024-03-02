class_name Rifleman extends Enemy

var is_standing: bool = false

func get_new_animation():
	if is_dead():
		return "death"
	if _state == STATE.IDLE:
		return "idle"
	elif _state == STATE.ALERT:
		if !is_standing:
			return "stand"
		if $Rifle.shoot(-$RiflemanSprite.scale.x):
			return "shoot"
		if $Rifle.is_empty():
			return "reload"
	
func _enemy_is_standing():
	is_standing = true
	
# Called when the node enters the scene tree for the first time.
func _ready():
	walking_direction = -1.0
	_state = STATE.IDLE
	pass

func check_player_proximity():
	if _state != STATE.DEAD:
		if(self.position.x - player_position) <= 150:
			_state = STATE.ALERT
	
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
		
	var animation = get_new_animation()
	if animation != null and animation != _animation_player.current_animation:
		_animation_player.play(animation)
	pass

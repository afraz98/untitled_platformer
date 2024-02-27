class_name Rifleman extends Enemy

var is_standing: bool = false

func get_new_animation():
	if _state == STATE.IDLE:
		return "idle"
	elif _state == STATE.FIRING: 
		if !is_standing:
			return "stand"
		return "shoot"
	return "death"

func _enemy_is_standing():
	is_standing = true
	
# Called when the node enters the scene tree for the first time.
func _ready():
	walking_direction = -1.0
	_state = STATE.IDLE
	pass

func shoot():
	get_node(^"Rifle").shoot(-$RiflemanSprite.scale.x)

func check_player_proximity():
	if _state != STATE.DEAD:
		if(self.position.x - player_position) <= 150:
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

	if is_standing:
		shoot()
		
	var animation = get_new_animation()
	if animation != _animation_player.current_animation:
		_animation_player.play(animation)
	pass

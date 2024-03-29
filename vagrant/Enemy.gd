class_name Enemy extends CharacterBody2D

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var _animation_player = $AnimationPlayer

signal enemy_killed(enemy)
var player_position: int = 0;

# Acceleration for walking
const WALK_FORCE = 600

# Maximum x velocity while walking
const WALK_MAX_SPEED = 150

# Crouching acceleration
const CROUCH_FORCE = 300

# Maximum x velocity while crouched
const CROUCH_MAX_SPEED = 100

# Stopping [de]acceleration
const STOP_FORCE = 1300

# Maximum y velocity while jumping
const JUMP_SPEED = 500

var walking_direction = 0
var initial_position_x = 0
var _state := STATE.PATROLLING

enum STATE { IDLE, PATROLLING, DEAD, SEARCHING, FEAR, FLEEING, ALERT, CHEER }

func get_new_animation():
	if _state == STATE.PATROLLING:
		return "walk"
	return "death"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_state = STATE.PATROLLING
	velocity.x = -WALK_MAX_SPEED
	pass

func _flee():
	_state = STATE.FLEEING
	get_new_animation()
	
func destroy() -> void:
	velocity = Vector2.ZERO
	_state = STATE.DEAD
	self.set_collision_mask_value(2, false)
	self.set_collision_mask_value(3, false)
	
func is_dead():
	return _state == STATE.DEAD
	
func _enemy_died_nearby(enemy: Enemy):
	pass
	
func _on_player_death():
	_state == STATE.IDLE
	
func broadcast_death():
	enemy_killed.emit(self)

func update_player_position(pos_x):
	player_position = pos_x
		
func check_player_proximity():
	pass

func _physics_process(delta):
	if not $FloorDetectorLeft.is_colliding():
		velocity.x = -WALK_MAX_SPEED
	elif not $FloorDetectorRight.is_colliding():
		velocity.x = WALK_MAX_SPEED

	if is_on_wall():
		velocity.x = -velocity.x
	
	# Flip sprite if moving left
	if velocity.x != 0:
		$EnemySprite.flip_h = velocity.x > 0

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

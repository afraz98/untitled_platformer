class_name Enemy extends CharacterBody2D

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var _animation_player = $AnimationPlayer

# Acceleration for walking
const WALK_FORCE = 600

# Maximum x velocity while walking
const WALK_MAX_SPEED = 200

# Crouching acceleration
const CROUCH_FORCE = 300

# Maximum x velocity while crouched
const CROUCH_MAX_SPEED = 100

# Stopping [de]acceleration
const STOP_FORCE = 1300

# Maximum y velocity while jumping
const JUMP_SPEED = 500

# Maximum distance away from its initial position
# that the enemy is allowed to move
const MAXIMUM_X_DISTANCE = 100

var walking_direction = 0
var initial_position_x = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	walking_direction = -1.0
	velocity.x = -WALK_MAX_SPEED
	pass

func get_new_animation():
	return "walk"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_animation_player.play(get_new_animation())

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
	pass

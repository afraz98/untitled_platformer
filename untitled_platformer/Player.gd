class_name Player extends CharacterBody2D

const WALK_FORCE = 600
const WALK_MAX_SPEED = 200

const CROUCH_FORCE = 300
const CROUCH_MAX_SPEED = 100

const STOP_FORCE = 1300
const JUMP_SPEED = 500

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var _animation_player = $AnimationPlayer

func is_crouching():
	if Input.is_action_pressed("crouch"):
		return true
	return false

func get_new_animation():
	if is_on_floor():
		if Input.is_action_pressed("crouch"):
			if velocity.x != 0.0:
				return "crouch_walk"
			return "crouch"
		if velocity.x != 0.0:
			return "walk"
		return "idle"
	else:
		if velocity.y > 0.0:
			return "fall"
		return "jump"
	return "idle" # By default return the idle animation

func update_hitbox():
	if is_crouching():
		$PlayerHitbox.disabled = true
		$PlayerCrouchHitbox.disabled = false
	else:
		$PlayerHitbox.disabled = false
		$PlayerCrouchHitbox.disabled = true
	pass

func _physics_process(delta):
	_animation_player.play(get_new_animation())
	update_hitbox()
		
	if velocity.x != 0:
		$PlayerSprite.flip_h = velocity.x < 0

	if is_crouching(): # Player should move at half speed if crouched
		# Horizontal movement code. First, get the player's input.
		var walk = CROUCH_FORCE * (Input.get_axis(&"move_left", &"move_right"))
		
		# Slow down the player if they're not trying to move.
		if abs(walk) < CROUCH_FORCE * 0.2:
			# The velocity, slowed down a bit, and then reassigned.
			velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
		else:
			velocity.x += walk * delta
		
		# Clamp to the maximum horizontal movement speed.
		velocity.x = clamp(velocity.x, -CROUCH_MAX_SPEED, CROUCH_MAX_SPEED)		
	else:
		# Horizontal movement code. First, get the player's input.
		var walk = WALK_FORCE * (Input.get_axis(&"move_left", &"move_right"))
		
		# Slow down the player if they're not trying to move.
		if abs(walk) < WALK_FORCE * 0.2:
			# The velocity, slowed down a bit, and then reassigned.
			velocity.x = move_toward(velocity.x, 0, STOP_FORCE * delta)
		else:
			velocity.x += walk * delta
		
		# Clamp to the maximum horizontal movement speed.
		velocity.x = clamp(velocity.x, -WALK_MAX_SPEED, WALK_MAX_SPEED)

	# Vertical movement code. Apply gravity.
	velocity.y += gravity * delta

	# Move based on the velocity and snap to the ground.
	move_and_slide()

	# Check for jumping. is_on_floor() must be called after movement code.
	if is_on_floor() and Input.is_action_just_pressed(&"jump"):
		velocity.y = -JUMP_SPEED


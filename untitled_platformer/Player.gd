class_name Player extends CharacterBody2D

const WALK_FORCE = 600
const WALK_MAX_SPEED = 200

const CROUCH_FORCE = 300
const CROUCH_MAX_SPEED = 100

const STOP_FORCE = 1300
const JUMP_SPEED = 500

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func is_crouching():
	if Input.is_action_pressed("crouch"):
		return true
	return false

func get_new_animation(is_shooting, is_reloading):
	if is_shooting:
		return "shoot"
	if is_reloading:
		return "reload"
	if is_on_floor():
		if Input.is_action_pressed("crouch"):
			if velocity.x != 0.0:
				return "crouch_walk"
			return "crouch"
		if velocity.x != 0.0:
			return "walk"
		return "idle"
	else:
		if velocity.x != 0.0:
			return "stride"
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
	# Flip sprite if moving left
	if velocity.x < 0:
		$PlayerSprite.scale.x = -1.0
	elif velocity.x > 0:
		$PlayerSprite.scale.x = 1.0
	
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

	var is_shooting := false
	if Input.is_action_just_pressed("shoot"):
		is_shooting = $PlayerSprite.get_node(^"Gun").shoot($PlayerSprite.scale.x)

	var is_reloading := false
	if Input.is_action_just_pressed("reload"):
		is_reloading = $PlayerSprite.get_node(^"Gun").reload()
	
	var animation = get_new_animation(is_shooting, is_reloading)
	if animation != $AnimationPlayer.current_animation and $Timer.is_stopped():
		if is_shooting:
			$Timer.wait_time = 0.4
			$Timer.start()
		if is_reloading:
			$Timer.wait_time = 1.2
			$Timer.start()
		$AnimationPlayer.play(animation)

	update_hitbox()



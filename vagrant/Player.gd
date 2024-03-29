class_name Player extends CharacterBody2D

const WALK_FORCE = 600
const WALK_MAX_SPEED = 200

const CROUCH_FORCE = 300
const CROUCH_MAX_SPEED = 100

const STOP_FORCE = 1300
const JUMP_SPEED = 250 

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_alive: bool = true

signal player_moved(x: int)
signal gun_shot()
signal player_reloaded()
signal player_dead()

func is_crouching():
	return false

func get_new_upper_animation(is_shooting, is_reloading, is_throwing):
	if is_shooting:
		return "shoot"
	if is_reloading:
		return "reload"
	if is_throwing:
		return "throw"
	if velocity.y > 0.0:
			return "fall"
	if velocity.x != 0.0:
			return "walk"
	return "idle" # By default return the idle animation
	
func get_new_lower_animation():
	if is_on_floor():
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

func is_dead():
	return is_alive == false

func _player_killed() -> void:
	velocity = Vector2.ZERO
	is_alive = false
	
func destroy() -> void:
	# Disable collision	
	self.set_collision_mask_value(2, false)
	self.set_collision_mask_value(3, false)
	
	# Switch to full-body sprite
	$UpperBody.set_visible(false)
	$LowerBody.set_visible(false)
	$FullBody.set_visible(true)
	
	$FullBody.play_animation("death")
	var is_alive = false
	player_dead.emit()

func _ready():
	$UpperBody/Gun.position.x = $UpperBody.position.x + 19
	$UpperBody/Gun.position.y = $UpperBody.position.y + 4

func _physics_process(delta):
	# Flip sprite if moving left
	if velocity.x < 0:
		$UpperBody.position.x = 7 # Is there a better way to do this?
		$UpperBody.scale.x = -1.0
		$LowerBody.scale.x = -1.0
	elif velocity.x > 0:
		$UpperBody.position.x = 14 # Is there a better way to do this?
		$UpperBody.scale.x = 1.0
		$LowerBody.scale.x = 1.0
		
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
		
		if !is_dead():
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
	if is_on_floor() and Input.is_action_just_pressed(&"jump") and !is_dead():
		velocity.y = -JUMP_SPEED
	
	if velocity.x != 0:
		emit_signal("player_moved", self.position.x)

	var is_shooting := false
	var is_reloading := false
	var is_throwing := false
	
	if !self.is_dead():
		if Input.is_action_just_pressed("shoot"):
			is_shooting = $UpperBody.get_node(^"Gun").shoot($UpperBody.scale.x)
			if is_shooting:
				gun_shot.emit()
		
		if Input.is_action_just_pressed("throw"):
			is_throwing = $UpperBody.get_node(^"GrenadeThrower").throw_grenade($UpperBody.scale.x)
			pass
		
		if Input.is_action_just_pressed("reload"):
			is_reloading = $UpperBody.get_node(^"Gun").reload()
			if is_reloading:
				player_reloaded.emit()
	
	$UpperBody.play_animation(get_new_upper_animation(is_shooting, is_reloading, is_throwing), is_shooting, is_reloading, is_throwing)
	$LowerBody.play_animation(get_new_lower_animation())	
	update_hitbox()



extends Node2D

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var _animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func get_new_animation():
	return "walk"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	_animation_player.play(get_new_animation())
	pass

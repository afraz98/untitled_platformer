extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var mob_types = $EnemySprite.sprite_frames.get_animation_names() # ['walk', 'swim', 'fly']
	$EnemySprite.play(mob_types[randi() % mob_types.size()])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_enemy_notifier_screen_exited():
	queue_free()
	pass

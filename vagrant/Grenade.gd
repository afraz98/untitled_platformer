class_name Grenade extends RigidBody2D

func play_animation(animation):
	$AnimationPlayer.play(animation)
	
func destroy() -> void:
	play_animation("destroy")

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		if !(body as CharacterBody2D).is_dead():
			(body as CharacterBody2D).destroy()
	destroy()

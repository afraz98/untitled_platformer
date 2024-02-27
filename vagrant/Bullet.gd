class_name Bullet extends RigidBody2D

func destroy() -> void:
	$AnimationPlayer.play(&"destroy")
	
func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		if !(body as CharacterBody2D).is_dead():
			(body as CharacterBody2D).destroy()
	destroy()



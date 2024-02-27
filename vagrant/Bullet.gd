class_name Bullet extends RigidBody2D

func destroy() -> void:
	$AnimationPlayer.play(&"destroy")
	
func _on_body_entered(body: Node) -> void:
	if body is Enemy:
		if !(body as Enemy).is_dead():
			(body as Enemy).destroy()
	destroy()



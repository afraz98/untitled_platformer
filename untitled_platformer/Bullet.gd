class_name Bullet extends RigidBody2D

func destroy() -> void:
	$AnimationPlayer.play(&"destroy")
	queue_free()

func _on_body_entered(body: Node) -> void:
	if body is Enemy:
		(body as Enemy).destroy()

	


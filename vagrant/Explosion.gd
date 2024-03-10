class_name Explosion extends RigidBody2D

func play_animation(animation):
	$AnimationPlayer.play("animation")

func explode():
	play_animation("explode")

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		if !(body as CharacterBody2D).is_dead():
			(body as CharacterBody2D).destroy()
	explode()

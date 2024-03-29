class_name Bullet extends RigidBody2D

var initial_position: int = 0

func destroy() -> void:
	$AnimationPlayer.play(&"destroy")

func ready() -> void:
	initial_position = self.position.x
		
func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		if !(body as CharacterBody2D).is_dead():
			(body as CharacterBody2D).destroy()
	destroy()


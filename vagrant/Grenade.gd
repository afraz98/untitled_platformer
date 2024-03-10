class_name Grenade extends RigidBody2D
const Explosion = preload("res://Explosion.tscn")

func play_animation(animation) -> void:
	$AnimationPlayer.play(animation)

func explode() -> void:
	var explosion := Explosion.instantiate() as Explosion
	explosion.global_position = global_position
	
	queue_free()
	pass

func destroy() -> void:
	play_animation("destroy")

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		explode()

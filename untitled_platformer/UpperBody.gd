extends Sprite2D

func play_animation(animation, is_shooting, is_reloading):
	if animation != $AnimationPlayer.current_animation and $Timer.is_stopped():
		if is_shooting:
			$Timer.wait_time = 1.9
			$Timer.start()
		if is_reloading:
			$Timer.wait_time = 1.9
			$Timer.start()
		$AnimationPlayer.play(animation)


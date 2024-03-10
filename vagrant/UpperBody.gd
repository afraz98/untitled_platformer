class_name UpperBody extends Sprite2D

func play_animation(animation, is_shooting, is_reloading, is_throwing):
	if $Timer.is_stopped() and animation != $AnimationPlayer.current_animation:
		if is_shooting:
			$Timer.wait_time = 0.2
			$Timer.start()
		if is_reloading:
			$Timer.wait_time = 1.9
			$Timer.start()
		if is_throwing:
			$Timer.wait_time = 0.6
			$Timer.start()
		$AnimationPlayer.play(animation)


extends Node

var enemies := []

# Called when the node enters the scene tree for the first time.
func _ready():
	enemies.append($HidingEnemy)
	
	get_node("Player").player_moved.connect(_on_player_moved)
	get_node("HidingEnemy").enemy_killed.connect(_on_enemy_killed)
	
func _on_player_moved(pos_x):
	for enemy in enemies:
		enemy.update_player_position(pos_x)
		
func _on_enemy_killed(enemy):
	enemies[0].queue_free()
	enemies.remove_at(0)
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"pause"):
		var tree := get_tree()
		tree.paused = not tree.paused
		if tree.paused:
			$PauseMenu.open()
		else:
			$PauseMenu.close()
		get_tree().root.set_input_as_handled()

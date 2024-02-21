extends Node2D

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var player = $Player as Player
@onready var hiding_enemy = $HidingEnemy as HidingEnemy

var enemies := []

func _ready():
	enemies.append(hiding_enemy)
	player.player_moved.connect(_on_player_moved)
	for enemy in enemies:
		enemy.enemy_killed.connect(_on_enemy_killed)

func _on_player_moved(pos_x):
	for enemy in enemies:
		enemy.update_player_position(pos_x)

func _on_enemy_killed(enemy):
	enemies[0].queue_free()
	enemies.remove_at(0)
	pass

extends Node2D

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var player = $Player as Player
@onready var hiding_enemy = $HidingEnemy as HidingEnemy
@onready var stationary_enemy = $StationaryEnemy as StationaryEnemy
@onready var stationary_enemy_2 = $StationaryEnemy2 as StationaryEnemy
@onready var rifleman = $Rifleman as Rifleman

signal game_over()

var enemies := []

func _ready():
	enemies.append(hiding_enemy)
	enemies.append(stationary_enemy)
	enemies.append(stationary_enemy_2)
	enemies.append(rifleman)

	player.player_dead.connect(_on_player_death)
	player.player_moved.connect(_on_player_moved)
	for enemy in enemies:
		enemy.enemy_killed.connect(_on_enemy_killed)

func _on_player_death():
	for enemy in enemies:
		enemy._on_player_death()
	game_over.emit()
	pass

func _on_player_moved(pos_x: int):
	for enemy in enemies:
		enemy.update_player_position(pos_x)

func broadcast_death(dead_enemy: Enemy): 
	# Broadcast a death to all actors on the level
	for enemy in enemies:
		enemy._enemy_died_nearby(dead_enemy)
	pass

func _on_enemy_killed(enemy: Enemy):
	broadcast_death(enemy)
	enemy.queue_free()
	enemies.erase(enemy)
	pass

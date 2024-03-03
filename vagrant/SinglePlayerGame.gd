extends Node

var enemies := []
@onready var pause_menu = $PauseMenuLayer/PauseMenu as PauseMenu
@onready var user_interface = $UserInterfaceLayer/UserInterface
@onready var player = $Level/Player as Player
@onready var level = $Level

var current_ammo_count: int = 10
var total_ammo_count: int = 10

func set_ammo_count():
	user_interface.set_ammo_count(current_ammo_count, total_ammo_count)
	pass

func _ready():
	set_ammo_count()
	player.gun_shot.connect(_on_player_gun_shot)
	player.player_reloaded.connect(_on_player_reload)
	level.game_over.connect(game_over)

func _on_player_gun_shot():
	current_ammo_count -= 1
	set_ammo_count()
	pass
	
func _on_player_reload():
	current_ammo_count = 10
	set_ammo_count()

func game_over():
	print("Game over!")
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"fullscreen"):
		var mode := DisplayServer.window_get_mode()
		if mode == DisplayServer.WINDOW_MODE_FULLSCREEN or mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		get_tree().root.set_input_as_handled()

	if event.is_action_pressed(&"pause"):
		var tree := get_tree()
		tree.paused = not tree.paused
		if tree.paused:
			pause_menu.open()
		else:
			pause_menu.close()
		get_tree().root.set_input_as_handled()

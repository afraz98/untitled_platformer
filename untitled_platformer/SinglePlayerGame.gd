extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Player").player_moved.connect(_on_player_moved)
	
func _on_player_moved(pos_x):
	$HidingEnemy.update_player_position(pos_x)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

extends Control

var current_ammo_count: int = 0
var total_ammo_count: int = 0

func set_ammo_count(current_ammo_count, total_ammo_count):
	$UserInterfacePanel/AmmoLabel.set_text("%s/%s" % [current_ammo_count, total_ammo_count])

# Called when the node enters the scene tree for the first time.
func _ready():
	set_ammo_count(0,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

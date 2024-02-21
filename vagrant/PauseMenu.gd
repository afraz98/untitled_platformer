class_name PauseMenu extends Control

@export var fade_in_duration := 0.3
@export var fade_out_duration := 0.2

@onready var center_container := $ColorRect/CenterContainer as CenterContainer
@onready var resume_button := center_container.get_node(^"VBoxContainer/ResumeButton") as Button
@onready var quit_button := center_container.get_node(^"VBoxContainer/QuitButton") as Button


func _ready() -> void:
	resume_button.pressed.connect(_on_resume_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)
	hide()

func open() -> void:
	show()
	resume_button.grab_focus()

	modulate.a = 0.0
	center_container.anchor_bottom = 0.5
	var tween := create_tween()
	tween.tween_property(self, ^"modulate:a", 1.0, fade_in_duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(center_container, ^"anchor_bottom", 1.0, fade_out_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func close() -> void:
	var tween := create_tween()
	modulate.a = 0.0
	tween.tween_property(self, ^"modulate:a", 0.0, fade_out_duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(center_container, ^"anchor_bottom", 0.5, fade_out_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_callback(hide)

func _on_quit_button_pressed() -> void:
	if visible:
		get_tree().quit()

func _on_resume_button_pressed():
	close()

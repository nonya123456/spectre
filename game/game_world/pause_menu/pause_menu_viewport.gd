extends SubViewportContainer

signal quit_button_pressed

@export var button_pressed_player_scene: PackedScene = preload("res://game/shared/sounds/button_pressed_player.tscn")


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_pause"):
		visible = !visible
		get_tree().paused = !get_tree().paused

		if visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_resume_button_pressed() -> void:
	visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_play_button_pressed_sound()


func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	_play_button_pressed_sound()
	quit_button_pressed.emit()


func _play_button_pressed_sound() -> void:
	var button_pressed_player: AudioStreamPlayer = button_pressed_player_scene.instantiate()
	get_tree().get_root().add_child(button_pressed_player)
	button_pressed_player.finished.connect(func() -> void:
		button_pressed_player.queue_free()
	)

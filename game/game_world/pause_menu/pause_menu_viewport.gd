extends SubViewportContainer

signal quit_button_pressed

@onready var button_pressed_player: AudioStreamPlayer = $ButtonPressedPlayer


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
	button_pressed_player.play()


func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	button_pressed_player.play()
	await get_tree().create_timer(0.2).timeout
	quit_button_pressed.emit()

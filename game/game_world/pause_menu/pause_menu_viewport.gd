extends SubViewportContainer

signal quit_button_pressed


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_pause"):
		visible = !visible
		get_tree().paused = !get_tree().paused

		if visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	quit_button_pressed.emit()

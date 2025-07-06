class_name MainMenu

extends Node

signal play_button_pressed
signal quit_button_pressed

var has_play_button_pressed: bool
var has_quit_button_pressed: bool

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_play_button_pressed() -> void:
	if has_play_button_pressed:
		return

	has_play_button_pressed = true
	play_button_pressed.emit()


func _on_credits_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	if has_quit_button_pressed:
		return

	has_quit_button_pressed = true
	quit_button_pressed.emit()

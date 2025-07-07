class_name MainMenu

extends Node

signal play_button_pressed
signal quit_button_pressed

var has_play_button_pressed: bool
var has_quit_button_pressed: bool

@onready var title: Node = $SubViewportContainer/SubViewport/Title
@onready var buttons: Node = $SubViewportContainer/SubViewport/Buttons
@onready var credits: Node = $SubViewportContainer/SubViewport/Credits
@onready var credits_text: RichTextLabel = $SubViewportContainer/SubViewport/Credits/ScrollContainer/VBoxContainer/RichTextLabel

@onready var button_pressed_player: AudioStreamPlayer = $ButtonPressedPlayer


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	credits_text.text = "Developed using Godot Engine\n\nLicense for Godot Engine\n\n" + Engine.get_license_text()


func _on_play_button_pressed() -> void:
	button_pressed_player.play()
	if has_play_button_pressed:
		return

	has_play_button_pressed = true
	play_button_pressed.emit()


func _on_credits_button_pressed() -> void:
	button_pressed_player.play()
	credits.visible = true
	title.visible = false
	buttons.visible = false


func _on_quit_button_pressed() -> void:
	button_pressed_player.play()
	if has_quit_button_pressed:
		return

	has_quit_button_pressed = true
	quit_button_pressed.emit()


func _on_back_button_pressed() -> void:
	button_pressed_player.play()
	credits.visible = false
	title.visible = true
	buttons.visible = true

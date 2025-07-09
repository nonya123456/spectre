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
@onready var settings: Node = $SubViewportContainer/SubViewport/Settings
@onready var master_volume_h_slider: HSlider = $SubViewportContainer/SubViewport/Settings/VBoxContainer/MasterVolume/HSlider

@export var button_pressed_player_scene: PackedScene = preload("res://game/shared/sounds/button_pressed_player.tscn")

var master_bus_index: int


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	credits_text.text = "Developed using Godot Engine\n\nLicense for Godot Engine\n\n" + Engine.get_license_text()
	master_bus_index = AudioServer.get_bus_index("Master")
	master_volume_h_slider.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus_index))


func _on_play_button_pressed() -> void:
	_play_button_pressed_sound()
	if has_play_button_pressed:
		return

	has_play_button_pressed = true
	play_button_pressed.emit()


func _on_settings_button_pressed() -> void:
	_play_button_pressed_sound()
	settings.visible = true
	credits.visible = false
	title.visible = false
	buttons.visible = false


func _on_credits_button_pressed() -> void:
	_play_button_pressed_sound()
	credits.visible = true
	settings.visible = false
	title.visible = false
	buttons.visible = false


func _on_quit_button_pressed() -> void:
	if has_quit_button_pressed:
		return

	has_quit_button_pressed = true
	quit_button_pressed.emit()


func _on_back_button_pressed() -> void:
	_play_button_pressed_sound()
	credits.visible = false
	settings.visible = false
	title.visible = true
	buttons.visible = true


func _play_button_pressed_sound() -> void:
	var button_pressed_player: AudioStreamPlayer = button_pressed_player_scene.instantiate()
	get_tree().get_root().add_child(button_pressed_player)
	button_pressed_player.finished.connect(func() -> void:
		button_pressed_player.queue_free()
	)


func _on_master_volume_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(value))

extends Node

@export var main_menu_scene: PackedScene = preload("res://game/main_menu/main_menu.tscn")
@export var game_world_scene: PackedScene = preload("res://game/game_world/game_world.tscn")

@onready var current_scene: Node = $MainMenu


func _on_main_menu_play_button_pressed() -> void:
	var game_world: Node = game_world_scene.instantiate()
	add_child(game_world)
	current_scene.queue_free()
	current_scene = game_world


func _on_main_menu_quit_button_pressed() -> void:
	get_tree().quit()

extends Node

@export var main_menu_scene: PackedScene = preload("res://game/main_menu/main_menu.tscn")
@export var game_world_scene: PackedScene = preload("res://game/game_world/game_world.tscn")

@onready var current_scene: Node = $MainMenu


func _ready() -> void:
	print(Engine.get_license_text())


func _on_main_menu_play_button_pressed() -> void:
	var game_world: GameWorld = game_world_scene.instantiate()
	game_world.ended.connect(_on_game_world_ended)
	add_child(game_world)
	current_scene.queue_free()
	current_scene = game_world


func _on_main_menu_quit_button_pressed() -> void:
	get_tree().quit()


func _on_game_world_ended() -> void:
	var main_menu: MainMenu = main_menu_scene.instantiate()
	main_menu.play_button_pressed.connect(_on_main_menu_play_button_pressed)
	main_menu.quit_button_pressed.connect(_on_main_menu_quit_button_pressed)
	add_child(main_menu)
	current_scene.queue_free()
	current_scene = main_menu

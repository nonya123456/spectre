class_name GameWorld

extends Node

signal ended

@onready var spectre: Spectre = $Spectre
@onready var player: Player = $Player
@onready var map: Node3D = $Map
@onready var world_viewport: SubViewportContainer = $CanvasLayer/WorldViewport
@onready var player_cam: Camera3D = $CanvasLayer/WorldViewport/SubViewport/PlayerViewport/SubViewport/Camera3D
@onready var view_model_cam: Camera3D = $CanvasLayer/WorldViewport/SubViewport/ViewModelViewport/SubViewport/Camera3D
@onready var label: Label = $CanvasLayer/LabelViewport/SubViewport/Label
@onready var orb_collected_player: AudioStreamPlayer = $OrbCollectedPlayer
@onready var forced_look_player: AudioStreamPlayer = $ForcedLookPlayer
@onready var forced_look_entered_player: AudioStreamPlayer = $ForcedLookEnteredPlayer

@export var width: int = 10
@export var height: int = 10
@export var node_size: float = 3.0
@export var node_height: float = 6.0
@export var wall_thickness: float = 0.5
@export var illusion_scene: PackedScene = preload("res://game/game_world/spectre/illusion.tscn")
@export var block_scene: PackedScene = preload("res://game/game_world/block/block.tscn")
@export var orb_scene: PackedScene = preload("res://game/game_world/orb/orb.tscn")
@export var orb_count: int = 10

var current_orb_count: int

var zoom_factor: float = 1.0
var zoom_factor_change_speed: float = 5.0
var forced_look: bool = false
var label_timer: float = 0.0

var occupied_cells: Dictionary = {}

var has_ended: bool

var current_drain_rate_multiplier: float = 5.0
var current_active_duration: float = 25.0


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	randomize()
	var rng_seed: int = randi()

	var maze_graph: MazeGraph = MazeGenerator.generate_maze(rng_seed, width, height)
	var map_height: float = node_size * height + wall_thickness * (height + 1)
	var map_width: float = node_size * width + wall_thickness * (width + 1)

	var floor_block: Block = block_scene.instantiate()
	floor_block.set_size(Vector3(map_height, wall_thickness, map_width))
	map.add_child(floor_block)

	var ceiling_block: Block = block_scene.instantiate()
	ceiling_block.set_size(Vector3(map_height, wall_thickness, map_width))
	ceiling_block.position.y = node_height
	map.add_child(ceiling_block)

	# Outer wall 1: along X axis (back wall)
	var outer_wall_1: Block = block_scene.instantiate()
	outer_wall_1.set_size(Vector3(map_height, node_height, wall_thickness))
	outer_wall_1.position = Vector3(0, node_height / 2, - (map_width - wall_thickness) / 2)
	map.add_child(outer_wall_1)

	# Outer wall 2: along X axis (front wall)
	var outer_wall_2: Block = block_scene.instantiate()
	outer_wall_2.set_size(Vector3(map_height, node_height, wall_thickness))
	outer_wall_2.position = Vector3(0, node_height / 2, (map_width - wall_thickness) / 2)
	map.add_child(outer_wall_2)

	# Outer wall 3: along Z axis (left wall)
	var outer_wall_3: Block = block_scene.instantiate()
	outer_wall_3.set_size(Vector3(wall_thickness, node_height, map_width))
	outer_wall_3.position = Vector3(- (map_height - wall_thickness) / 2, node_height / 2, 0)
	map.add_child(outer_wall_3)

	# Outer wall 4: along Z axis (right wall)
	var outer_wall_4: Block = block_scene.instantiate()
	outer_wall_4.set_size(Vector3(wall_thickness, node_height, map_width))
	outer_wall_4.position = Vector3((map_height - wall_thickness) / 2, node_height / 2, 0)
	map.add_child(outer_wall_4)

	# Inner walls
	for i in range(height):
		for j in range(width):
			if j + 1 < width && !maze_graph.is_adjacent(i, j, i, j + 1):
				var wall: Block = block_scene.instantiate()
				wall.set_size(Vector3(node_size, node_height, wall_thickness))
				var pos_x: float = (i + 1) * (node_size + wall_thickness) - node_size / 2 - map_height / 2
				var pos_z: float = (j + 1) * (node_size + wall_thickness) + wall_thickness / 2 - map_width / 2
				wall.position = Vector3(pos_x, node_height / 2, pos_z)
				map.add_child(wall)

			if i + 1 < height && !maze_graph.is_adjacent(i, j, i + 1, j):
				var wall: Block = block_scene.instantiate()
				wall.set_size(Vector3(wall_thickness, node_height, node_size))
				var pos_x: float = (i + 1) * (node_size + wall_thickness) + wall_thickness / 2 - map_height / 2
				var pos_z: float = (j + 1) * (node_size + wall_thickness) - node_size / 2 - map_width / 2
				wall.position = Vector3(pos_x, node_height / 2, pos_z)
				map.add_child(wall)
	
	# Corners
	for i in range(height - 1):
		for j in range(width - 1):
			if !maze_graph.is_adjacent(i, j, i + 1, j) or !maze_graph.is_adjacent(i, j, i, j + 1) or \
			   !maze_graph.is_adjacent(i, j + 1, i + 1, j + 1) or !maze_graph.is_adjacent(i + 1, j, i + 1, j + 1):
				var corner: Block = block_scene.instantiate()
				corner.set_size(Vector3(wall_thickness, node_height, wall_thickness))
				var pos_x: float = (i + 1) * (node_size + wall_thickness) + wall_thickness / 2 - map_height / 2
				var pos_z: float = (j + 1) * (node_size + wall_thickness) + wall_thickness / 2 - map_width / 2
				corner.position = Vector3(pos_x, node_height / 2, pos_z)
				map.add_child(corner)

	var player_index: int = _get_available_cell()
	if player_index != -1:
		var pos: Vector2 = _get_node_center(player_index)
		player.position.x = pos.x
		player.position.z = pos.y
	
	spectre.target = player
	var spectre_index: int = _get_available_cell()
	if spectre_index != -1:
		spectre.index = spectre_index
		var pos: Vector2 = _get_node_center(spectre_index)
		spectre.position = Vector3(pos.x, 0.0, pos.y)
		spectre.activate(current_active_duration)
		occupied_cells[spectre_index] = null

	for i in range(orb_count):
		_spawn_orb()
	
	_show_text("%d" % [current_orb_count])


func _get_node_center(index: int) -> Vector2:
	var i: int = int(index / floor(width))
	var j: int = index % height
	var map_height: float = node_size * height + wall_thickness * (height + 1)
	var map_width: float = node_size * width + wall_thickness * (width + 1)
	var pos_x: float = (i + 1) * (node_size + wall_thickness) - node_size / 2 - map_height / 2
	var pos_z: float = (j + 1) * (node_size + wall_thickness) - node_size / 2 - map_width / 2
	return Vector2(pos_x, pos_z)


func _process(delta: float) -> void:
	_update_camera()
	_update_effects(delta)

	if label.visible:
		label_timer -= delta
		if label_timer < 0:
			label.visible = false


func _update_camera() -> void:
	var pos: Vector3 = player.get_marker_position()
	var rot: Vector3 = player.get_marker_rotation()
	player_cam.global_position = pos
	player_cam.global_rotation = rot
	view_model_cam.global_position = pos
	view_model_cam.global_rotation = rot


func _update_effects(delta: float) -> void:
	var target_force: float = 1.5 if forced_look else 1.0
	zoom_factor = move_toward(zoom_factor, target_force, delta * zoom_factor_change_speed)
	world_viewport.material.set_shader_parameter("zoom_factor", zoom_factor)

	var shake_intensity: float = 0.01 if forced_look else 0.0
	world_viewport.material.set_shader_parameter("shake_intensity", shake_intensity)


func _on_spectre_target_found(marker_position: Vector3) -> void:
	forced_look = true
	player.start_forced_look(marker_position, current_drain_rate_multiplier)
	forced_look_entered_player.play()
	forced_look_player.play()


func _on_spectre_target_lost() -> void:
	forced_look = false
	player.stop_forced_look()
	forced_look_player.stop()


func _spawn_orb() -> void:
	var index = _get_available_cell()
	if index == -1:
		return

	var orb: Orb = orb_scene.instantiate()
	var pos: Vector2 = _get_node_center(index)
	orb.index = index
	orb.position = Vector3(pos.x, 1.2, pos.y)
	orb.collected.connect(_on_orb_collected)
	add_child(orb)

	current_orb_count += 1

	occupied_cells[index] = null


func _show_text(text: String):
	label.text = text
	label.visible = true
	label_timer = 1.0


func _on_orb_collected(orb: Orb) -> void:
	occupied_cells.erase(orb.index)

	player.heal()

	current_orb_count -= 1
	if current_orb_count <= 0 and !has_ended:
		_show_text("YOU WIN")
		has_ended = true
		await get_tree().create_timer(1.0).timeout
		ended.emit()
	else:
		_show_text("%d" % [current_orb_count])
		orb_collected_player.play()
	
	if current_orb_count == 9:
		_spawn_illusion()
		current_drain_rate_multiplier = 8.0
	elif current_orb_count == 6:
		_spawn_illusion()
		current_drain_rate_multiplier = 12.0
		current_active_duration = 15.0
	elif current_orb_count == 4:
		_spawn_illusion()
		current_drain_rate_multiplier = 16.0
		current_active_duration = 10.0
	elif current_orb_count == 3:
		current_drain_rate_multiplier = 20.0
	elif current_orb_count == 2:
		_spawn_illusion()
		current_active_duration = 5.0

	
func _spawn_illusion() -> void:
	var index = _get_available_cell()
	if index == -1:
		return

	var illusion: Illusion = illusion_scene.instantiate()
	var pos: Vector2 = _get_node_center(index)
	illusion.index = index
	illusion.target = player
	illusion.position = Vector3(pos.x, 0.0, pos.y)
	illusion.inactive.connect(_on_illusion_inactive)
	add_child(illusion)

	occupied_cells[index] = null


func _on_illusion_inactive(illusion: Illusion) -> void:
	occupied_cells.erase(illusion.index)

	var index = _get_available_cell()
	if index == -1:
		return

	var pos: Vector2 = _get_node_center(index)
	illusion.index = index
	illusion.position = Vector3(pos.x, 0.0, pos.y)
	illusion.reset()

	occupied_cells[index] = null


func _get_available_cell() -> int:
	var possible_numbers: PackedInt32Array = []
	for i in range(0, width * height):
		if occupied_cells.has(i):
			continue
		possible_numbers.append(i)
	
	if possible_numbers.is_empty():
		return -1
	
	var random_index = randi() % possible_numbers.size()
	return possible_numbers[random_index]


func _on_spectre_inactive() -> void:
	occupied_cells.erase(spectre.index)

	var index: int = _get_available_cell()
	if index == -1:
		return

	spectre.index = index
	var pos: Vector2 = _get_node_center(index)
	spectre.position = Vector3(pos.x, 0.0, pos.y)
	spectre.activate(current_active_duration)

	occupied_cells[index] = null


func _on_player_died() -> void:
	if has_ended:
		return
	
	has_ended = true
	occupied_cells.erase(spectre.index)
	spectre.teleport_nearby(player.position)
	await get_tree().create_timer(1.0).timeout

	_show_text("YOU DIED")
	await get_tree().create_timer(1.0).timeout

	ended.emit()


func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_IN:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_pause_menu_viewport_quit_button_pressed() -> void:
	has_ended = true
	ended.emit()

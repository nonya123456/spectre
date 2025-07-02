class_name Spectre

extends Node3D

@onready var spectre_model: SpectreModel = $SpectreModel
@onready var marker: Marker3D = $Marker3D

var target: Node3D = null


func _physics_process(_delta: float) -> void:
    if target:
        var direction: Vector3 = target.global_position - global_position
        direction.y = 0
        direction = direction.normalized()
        look_at(global_position - direction, Vector3.UP)


func on_player_flashlight_toggled(is_light_visible: bool) -> void:
    if is_light_visible:
        spectre_model.set_emission_strength(2.0)
    else:
        spectre_model.set_emission_strength(0.0)

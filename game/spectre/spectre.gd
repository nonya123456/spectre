class_name Spectre

extends Node3D

@onready var spectre_model: SpectreModel = $SpectreModel


func on_player_flashlight_toggled(is_light_visible: bool) -> void:
    if is_light_visible:
        spectre_model.set_emission_strength(2.0)
    else:
        spectre_model.set_emission_strength(0.0)

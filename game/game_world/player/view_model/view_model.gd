class_name ViewModel

extends Node3D

@onready var hand: Node3D = $Hand
@export var hand_speed: float = 5.0
@export var max_sway_x: float = 0.1
@export var max_sway_y: float = 0.1


func _process(delta: float) -> void:
	hand.position.x = lerp(hand.position.x, 0.0, delta * hand_speed)
	hand.position.y = lerp(hand.position.y, 0.0, delta * hand_speed)


func sway(sway_amount: Vector2) -> void:
	hand.position.x = clamp(hand.position.x + sway_amount.x, -max_sway_x, max_sway_x)
	hand.position.y = clamp(hand.position.y + sway_amount.y, -max_sway_y, max_sway_y)

extends Node


func _ready() -> void:
    print("Hello from main.gd")


func _notification(what: int) -> void:
    if what == NOTIFICATION_APPLICATION_FOCUS_IN:
        Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    elif what == NOTIFICATION_APPLICATION_FOCUS_OUT:
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

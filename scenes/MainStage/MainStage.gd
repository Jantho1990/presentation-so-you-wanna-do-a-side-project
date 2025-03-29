extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
  Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(inputEvent: InputEvent) -> void:
  if Input.is_action_just_pressed("ui_cancel"):
    Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
  elif inputEvent is InputEventMouseButton and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass

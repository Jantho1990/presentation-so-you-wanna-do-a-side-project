extends Camera3D


@export var playerNode: Node
@export var presentationCamera: Node

@onready var _focusedNode := presentationCamera


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if Input.is_action_just_pressed('interact'):
    if _focusedNode == presentationCamera:
      _animate_to_player()
    elif _focusedNode == playerNode:
      _animate_to_presentation()


func _animate_to_player() -> void:
  make_current()
  _focusedNode = null
  global_position = presentationCamera.global_position
  global_rotation = presentationCamera.global_rotation
  var tween = create_tween().set_parallel(true)
  tween.tween_property(self, "position", playerNode.parts.camera.global_position, 0.5)
  tween.tween_property(self, "rotation", playerNode.parts.camera.global_rotation, 0.5)
  tween.tween_property(self, "fov", playerNode.parts.camera.fov, 0.5)
  await tween.finished
  playerNode.parts.camera.make_current()
  playerNode.freeze = false
  _focusedNode = playerNode


func _animate_to_presentation() -> void:
  make_current()
  _focusedNode = null
  playerNode.freeze = true
  global_position = playerNode.parts.camera.global_position
  global_rotation = playerNode.parts.camera.global_rotation
  var tween = create_tween().set_parallel(true)
  tween.tween_property(self, "position", presentationCamera.global_position, 0.5)
  tween.tween_property(self, "rotation", presentationCamera.global_rotation, 0.5)
  tween.tween_property(self, "fov", presentationCamera.fov, 0.5)
  await tween.finished
  presentationCamera.make_current()
  _focusedNode = presentationCamera

class_name PresentationLauncher
extends Control

@export var presentationScene: PackedScene
@export var launch_on_ready := true

var _presentationNode: Presentation


func _init() -> void:
  size_flags_horizontal = Control.SIZE_EXPAND_FILL
  size_flags_vertical = Control.SIZE_EXPAND_FILL
  set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)


func _ready() -> void:
  _make_presentation()
  
  if launch_on_ready:
    launch()
  
  
func _make_presentation() -> void:
  if not presentationScene:
    push_error('PresentationLauncher._make_presentation(): presentationScene is null, aborting.')
    return
  
  if get_child_count() > 0:
    for childNode in get_children():
      remove_child(childNode)
      childNode.queue_free()
  
  _presentationNode = presentationScene.instantiate()
  add_child(_presentationNode)
  
  
func launch() -> void:
  Presenter.activate_presentation(_presentationNode)
  Presenter.start_presentation()

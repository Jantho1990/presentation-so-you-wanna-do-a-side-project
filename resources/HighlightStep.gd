class_name HighlightStep
extends SlideStep


@export var highlight_color := Color('#ffeda1')
@export var animatedNodePaths : Array[NodePath]

var _animatedNodes : Array[Node]
var _old_modulates : Dictionary
var _slideTween : Tween


func _kill_tween() -> void:
  _slideTween.kill()
  _slideTween = null


func _update_old_modulate(value: Array) -> void:
  _animatedNodes = []
  _old_modulates = {}
  if not slide:
    await slide_set
    await slide.ready
  for animatedNodePath in animatedNodePaths:
    var animatedNode = slide.get_node(animatedNodePath)
    _animatedNodes.push_back(slide.get_node(animatedNodePath))
    _old_modulates[animatedNode] = animatedNode.modulate


func next() -> void:
  step_next_began.emit()
  if _slideTween:
    _kill_tween()
  else:
    _update_old_modulate(_animatedNodes)
  
  _slideTween = slide.create_tween().set_parallel(true)
  for animatedNode in _animatedNodes:
    _slideTween.tween_property(animatedNode, "modulate", highlight_color, animation_duration).from(_old_modulates[animatedNode])
  await _slideTween.finished
#  print('DBG: next finished %s' % [targetNodes[0].modulate])
  _slideTween = null
  step_next_ended.emit()
  
  
func previous() -> void:
  step_previous_began.emit()  
  if _slideTween:
    _kill_tween()
  _slideTween = slide.create_tween().set_parallel(true)
  for animatedNode in _animatedNodes:
    _slideTween.tween_property(animatedNode, "modulate", _old_modulates[animatedNode], animation_duration).from(highlight_color)
  await _slideTween.finished
  _slideTween = null
  step_previous_ended.emit()  

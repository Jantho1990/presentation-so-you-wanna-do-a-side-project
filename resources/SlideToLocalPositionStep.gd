class_name SlideToLocalPositionStep
extends SlideStep


@export var animatedNodePaths : Array[NodePath]
@export var target_position := Vector2.ZERO

var _animatedNodes : Array[Node]
var _old_positions : Dictionary
var _slideTween: Tween


func _kill_tween() -> void:
  _slideTween.kill()
  _slideTween = null


func _update_old_positions(value: Array) -> void:
  _animatedNodes = []
  _old_positions = {}
  if not slide:
    await slide_set
    await slide.ready
  for animatedNodePath in animatedNodePaths:
    var animatedNode = slide.get_node(animatedNodePath)
    _animatedNodes.push_back(slide.get_node(animatedNodePath))
    _old_positions[animatedNode] = animatedNode.position


# Runs when the slide moves to the next step.
# Interface function. Must be replaced by inhereting resources.
func next() -> void:
  step_next_began.emit()
  if _slideTween:
    _kill_tween()
  else:
    _update_old_positions(_animatedNodes)
  
  _slideTween = slide.create_tween().set_parallel(true)
  for animatedNode in _animatedNodes:
    _slideTween.tween_property(animatedNode, "position", target_position, animation_duration).from(_old_positions[animatedNode])
  
  await _slideTween.finished
  _slideTween = null
  step_next_ended.emit()
  
  
# Runs when the slide moves to the previous step.
# Interface function. Must be replaced by inhereting resources.  
func previous() -> void:
  step_previous_began.emit()
  if _slideTween:
    _kill_tween()
  
  _slideTween = slide.create_tween().set_parallel(true)
  for animatedNode in _animatedNodes:
    _slideTween.tween_property(animatedNode, "position", _old_positions[animatedNode], animation_duration).from(target_position)
  
  await _slideTween.finished
  _slideTween = null
  step_previous_ended.emit()

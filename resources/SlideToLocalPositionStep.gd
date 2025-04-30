class_name SlideToLocalPositionStep
extends SlideStep


@export var animatedNodePaths : Array[NodePath]: set = _set_animatedNodePaths
@export var target_position := Vector2.ZERO
enum AXES { X, Y, BOTH }
@export var axis: AXES = AXES.BOTH

var _animatedNodes : Array[Node]
var _old_positions : Dictionary
var _slideTween: Tween


func _set_animatedNodePaths(new_value: Array) -> void:
  animatedNodePaths = new_value
  _animatedNodes = []
  if not slide:
    await slide_set
    if not slide.is_inside_tree():
      await slide.tree_entered
  for animatedNodePath in animatedNodePaths:
    _animatedNodes.push_back(slide.get_node(animatedNodePath))


func _get_destination_position(targetNode: Control, target_position: Vector2) -> Vector2:
  var ret := targetNode.position
  match axis:
      AXES.X:
        ret.x = target_position.x
      AXES.Y:
        ret.y = target_position.y
      AXES.BOTH:
        ret = target_position
  return ret


func _kill_tween() -> void:
  _slideTween.kill()
  _slideTween = null


func _update_old_positions() -> void:
  _old_positions = {}
  for animatedNode in _animatedNodes:
    _old_positions[animatedNode] = animatedNode.position


# Runs when the slide moves to the next step.
# Interface function. Must be replaced by inhereting resources.
func next() -> void:
  step_next_began.emit()
  if _slideTween:
    _kill_tween()
  else:
    _update_old_positions()
  
  _slideTween = slide.create_tween().set_parallel(true)
  for animatedNode in _animatedNodes:
    var destination_position = _get_destination_position(animatedNode, target_position)
    _slideTween.tween_property(animatedNode, "position", destination_position, animation_duration).from(_old_positions[animatedNode])
  
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
    var origin_position = _get_destination_position(animatedNode, target_position)
    _slideTween.tween_property(animatedNode, "position", _old_positions[animatedNode], animation_duration).from(origin_position)
  
  await _slideTween.finished
  _slideTween = null
  step_previous_ended.emit()

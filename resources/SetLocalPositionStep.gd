class_name SetLocalPositionStep
extends SlideStep

@export var targetNodes : Array[NodePath]: set = _set_targetNodes
@export var target_position := Vector2.ZERO
enum AXES { X, Y, BOTH }
@export var axis: AXES = AXES.BOTH

var _targetNodes : Array[Node]
var _old_positions : Dictionary
var _slideTween: Tween


func _set_targetNodes(new_value: Array) -> void:
  targetNodes = new_value
  _targetNodes = []
  if not slide:
    await slide_set
    if not slide.is_inside_tree():
      await slide.tree_entered
  for targetNodePath in targetNodes:
    _targetNodes.push_back(slide.get_node(targetNodePath))


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
  for targetNode in _targetNodes:
    _old_positions[targetNode] = targetNode.position


# Runs when the slide moves to the next step.
func next() -> void:
  step_next_began.emit()
  
  _update_old_positions()
  
  for targetNode in _targetNodes:
    var new_position = _get_destination_position(targetNode, target_position)
    targetNode.position = new_position
    print('DBG: setting target node %s position %s new position %s actual position %s' % [targetNode.name, target_position, new_position, targetNode.position])
  
  step_next_ended.emit()
  
  
# Runs when the slide moves to the previous step.
func previous() -> void:
  step_previous_began.emit()
  
  for targetNode in _targetNodes:
    targetNode.position = _old_positions[targetNode]
  
  step_previous_ended.emit()

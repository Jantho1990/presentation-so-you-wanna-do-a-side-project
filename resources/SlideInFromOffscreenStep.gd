class_name SlideInFromOffscreenStep
extends SlideStep


const OFFSCREEN_BOTTOM = 1000.0
const OFFSCREEN_LEFT = -1600.0
const OFFSCREEN_RIGHT = 1600.0
const OFFSCREEN_TOP = -1000.0

enum FROM_DIRECTIONS {
  TOP, LEFT, RIGHT, BOTTOM
}
@export var from_direction : FROM_DIRECTIONS = FROM_DIRECTIONS.TOP
@export var animatedNodePaths : Array[NodePath]

var _slideTween: Tween


func _get_offscreen() -> Vector2:
  match from_direction:
    FROM_DIRECTIONS.TOP:
      return Vector2(0, OFFSCREEN_TOP)
    FROM_DIRECTIONS.LEFT:
      return Vector2(OFFSCREEN_LEFT, 0)
    FROM_DIRECTIONS.RIGHT:
      return Vector2(OFFSCREEN_RIGHT, 0)
    FROM_DIRECTIONS.BOTTOM:
      return Vector2(0, OFFSCREEN_BOTTOM)
  return Vector2.ZERO


func _kill_tween() -> void:
  _slideTween.kill()
  _slideTween = null


# Runs when the slide moves to the next step.
# Interface function. Must be replaced by inhereting resources.
func next() -> void:
  if _slideTween:
    _kill_tween()
  
  _slideTween = slide.create_tween().set_parallel(true)
  for animatedNodePath in animatedNodePaths:
    var animatedNode = slide.get_node(animatedNodePath)
    _slideTween.tween_property(animatedNode, "position", Vector2.ZERO, animation_duriation).from(_get_offscreen())
  
  await _slideTween.finished
  _slideTween = null
  
  
# Runs when the slide moves to the previous step.
# Interface function. Must be replaced by inhereting resources.  
func previous() -> void:
  if _slideTween:
    _kill_tween()
  
  _slideTween = slide.create_tween().set_parallel(true)
  for animatedNodePath in animatedNodePaths:
    var animatedNode = slide.get_node(animatedNodePath)
    _slideTween.tween_property(animatedNode, "position", _get_offscreen(), animation_duriation).from(Vector2.ZERO)
  
  await _slideTween.finished
  _slideTween = null

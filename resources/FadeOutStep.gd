class_name FadeOutStep
extends SlideStep


const FADE_OUT_COLOR_BEGIN = Color(1.0, 1.0, 1.0, 1.0)
const FADE_OUT_COLOR_END = Color(1.0, 1.0, 1.0, 0.0)

@export var targetNodes : Array[NodePath]

var _slideTween : Tween


func _kill_tween() -> void:
  _slideTween.kill()
  _slideTween = null


func next() -> void:
  step_next_began.emit()
  _slideTween = slide.create_tween().set_parallel(true)
  for targetNodePath in targetNodes:
    var targetNode = slide.get_node(targetNodePath)
    targetNode.modulate = FADE_OUT_COLOR_BEGIN
    _slideTween.tween_property(targetNode, "modulate", FADE_OUT_COLOR_END, animation_duration).from(FADE_OUT_COLOR_BEGIN)
  await _slideTween.finished
  _slideTween = null
  step_next_ended.emit()
  
  
func previous() -> void:
  step_previous_began.emit()  
  if _slideTween:
    _kill_tween()
  _slideTween = slide.create_tween().set_parallel(true)
  for targetNodePath in targetNodes:
    var targetNode = slide.get_node(targetNodePath)
    _slideTween.tween_property(targetNode, "modulate", FADE_OUT_COLOR_BEGIN, animation_duration).from(FADE_OUT_COLOR_END)
  await _slideTween.finished
  _slideTween = null
  step_previous_ended.emit()  

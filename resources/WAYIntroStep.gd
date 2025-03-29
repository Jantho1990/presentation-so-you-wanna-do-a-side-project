class_name WAYIntroStep
extends SlideStep


const FADE_IN_COLOR_BEGIN = Color(1.0, 1.0, 1.0, 0.0)
const FADE_IN_COLOR_END = Color(1.0, 1.0, 1.0, 1.0)

@export var textBulletPath : NodePath
@export var imageNodePath : NodePath


var _slideTween : Tween


func _kill_tween() -> void:
  _slideTween.kill()
  _slideTween = null


func next() -> void:
  step_next_began.emit()
  if _slideTween:
    _kill_tween()
  _slideTween = slide.create_tween().set_parallel(true)
  var textBullet = slide.get_node(textBulletPath)
  var imageNode = slide.get_node(imageNodePath)
  _slideTween.tween_property(textBullet, "modulate", FADE_IN_COLOR_END, animation_duration).from(FADE_IN_COLOR_BEGIN)
  _slideTween.tween_property(imageNode, "modulate", FADE_IN_COLOR_END, animation_duration).from(FADE_IN_COLOR_BEGIN)
  await _slideTween.finished
  _slideTween = null
  step_next_ended.emit()
  
  
func previous() -> void:
  step_previous_began.emit()
  if _slideTween:
    _kill_tween()
  _slideTween = slide.create_tween().set_parallel(true)
  var textBullet = slide.get_node(textBulletPath)
  var imageNode = slide.get_node(imageNodePath)
  _slideTween.tween_property(textBullet, "modulate", FADE_IN_COLOR_BEGIN, animation_duration).from(FADE_IN_COLOR_END)
  _slideTween.tween_property(imageNode, "modulate", FADE_IN_COLOR_BEGIN, animation_duration).from(FADE_IN_COLOR_END)
  await _slideTween.finished
  _slideTween = null
  step_previous_ended.emit()

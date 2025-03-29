class_name WAYAdvanceStep
extends SlideStep


const FADE_IN_COLOR_BEGIN = Color(1.0, 1.0, 1.0, 0.0)
const FADE_IN_COLOR_END = Color(1.0, 1.0, 1.0, 1.0)
const STABILIZE_TIME = 0.05

@export var fadeInPaths : Array[NodePath]
@export var fadeOutPaths : Array[NodePath]
@export var stabilizeInPaths : Array[NodePath]
@export var stabilizeOutPaths : Array[NodePath]


var _slideTween : Tween
var _stabilizeTween : Tween


func _kill_tween() -> void:
  _slideTween.kill()
  _stabilizeTween.kill()
  _slideTween = null
  _stabilizeTween = null


func next() -> void:
  step_next_began.emit()
  if _slideTween:
    _kill_tween()
  
  _slideTween = slide.create_tween().set_parallel(true)
  _stabilizeTween = slide.create_tween().set_parallel(true)
  
  for fadeInPath in fadeInPaths:
    var fadeIn = slide.get_node(fadeInPath)
    _slideTween.tween_property(fadeIn, "modulate", FADE_IN_COLOR_END, animation_duration).from(FADE_IN_COLOR_BEGIN)
  for fadeOutPath in fadeOutPaths:
    var fadeOut = slide.get_node(fadeOutPath)
    _slideTween.tween_property(fadeOut, "modulate", FADE_IN_COLOR_BEGIN, animation_duration).from(FADE_IN_COLOR_END)
  for stabilizeInPath in stabilizeInPaths:
    var stabilizeIn = slide.get_node(stabilizeInPath)
    stabilizeIn.show()
    _stabilizeTween.tween_property(stabilizeIn, "modulate", FADE_IN_COLOR_END, STABILIZE_TIME).from(FADE_IN_COLOR_BEGIN)
  for stabilizeOutPath in stabilizeOutPaths:
    var stabilizeOut = slide.get_node(stabilizeOutPath)
    stabilizeOut.hide()

  await _slideTween.finished
  
  _slideTween = null
  _stabilizeTween = null
  
  step_next_ended.emit()
  
  
func previous() -> void:
  step_previous_began.emit()
  
  if _slideTween:
    _kill_tween()
  
  _slideTween = slide.create_tween().set_parallel(true)
  _stabilizeTween = slide.create_tween().set_parallel(true)
  
  for fadeInPath in fadeInPaths:
    var fadeIn = slide.get_node(fadeInPath)
    _slideTween.tween_property(fadeIn, "modulate", FADE_IN_COLOR_BEGIN, animation_duration).from(FADE_IN_COLOR_END)
  for fadeOutPath in fadeOutPaths:
    var fadeOut = slide.get_node(fadeOutPath)
    _slideTween.tween_property(fadeOut, "modulate", FADE_IN_COLOR_END, animation_duration).from(FADE_IN_COLOR_BEGIN)
  for stabilizeInPath in stabilizeInPaths:
    var stabilizeIn = slide.get_node(stabilizeInPath)
    _stabilizeTween.tween_property(stabilizeIn, "modulate", FADE_IN_COLOR_BEGIN, STABILIZE_TIME).from(FADE_IN_COLOR_END)
    _stabilizeTween.chain().tween_callback(stabilizeIn.hide)
  for stabilizeOutPath in stabilizeOutPaths:
    var stabilizeOut = slide.get_node(stabilizeOutPath)
    _stabilizeTween.chain().tween_callback(stabilizeOut.show)
  
  await _slideTween.finished
  
  _slideTween = null
  _stabilizeTween = null
  
  step_previous_ended.emit()

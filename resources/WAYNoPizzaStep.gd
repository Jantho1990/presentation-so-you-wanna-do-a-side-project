class_name WAYNoPizzaStep
extends SlideStep


const INVISIBLE_COLOR = Color(1.0, 1.0, 1.0, 0.0)
const FADE_GRAY_COLOR = Color('#99999955')
const VISIBLE_COLOR = Color(1.0, 1.0, 1.0, 1.0)

@export var fadeGrayPaths : Array[NodePath]
@export var stabilizeInPaths : Array[NodePath]
@export var stabilizeOutPaths : Array[NodePath]
@export var grayscaleImagePath : NodePath


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
  
  var grayscaleShader = slide.get_node(grayscaleImagePath).material
  _slideTween.tween_property(grayscaleShader, "shader_parameter/gray_amount", 1.0, animation_duration).from(0.0)
  for fadeGrayPath in fadeGrayPaths:
    var fadeGray = slide.get_node(fadeGrayPath)
    _slideTween.tween_property(fadeGray, "modulate", FADE_GRAY_COLOR, animation_duration).from(VISIBLE_COLOR)
  for stabilizeInPath in stabilizeInPaths:
    var stabilizeIn = slide.get_node(stabilizeInPath)
    stabilizeIn.show()
    _stabilizeTween.tween_property(stabilizeIn, "modulate", VISIBLE_COLOR, animation_duration).from(INVISIBLE_COLOR)
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
  
  var grayscaleShader = slide.get_node(grayscaleImagePath).material
  _slideTween.tween_property(grayscaleShader, "shader_parameter/gray_amount", 0.0, animation_duration).from(1.0)
  for fadeGrayPath in fadeGrayPaths:
    var fadeGray = slide.get_node(fadeGrayPath)
    _slideTween.tween_property(fadeGray, "modulate", VISIBLE_COLOR, animation_duration).from(FADE_GRAY_COLOR)
  for stabilizeInPath in stabilizeInPaths:
    var stabilizeIn = slide.get_node(stabilizeInPath)
    _stabilizeTween.tween_property(stabilizeIn, "modulate", INVISIBLE_COLOR, animation_duration).from(VISIBLE_COLOR)
    _stabilizeTween.chain().tween_callback(stabilizeIn.hide)
  for stabilizeOutPath in stabilizeOutPaths:
    var stabilizeOut = slide.get_node(stabilizeOutPath)
    _stabilizeTween.chain().tween_callback(stabilizeOut.show)
  
  await _slideTween.finished
  
  _slideTween = null
  _stabilizeTween = null
  
  step_previous_ended.emit()

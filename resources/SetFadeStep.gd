class_name SetFadeStep
extends SlideStep

const FADE_IN_COLOR = Color(1.0, 1.0, 1.0, 1.0)
const FADE_OUT_COLOR = Color(1.0, 1.0, 1.0, 0.0)

enum FADE { IN, OUT }
@export var fade: FADE: set = _set_fade
@export var targetNodes : Array[NodePath]

var _fade_color: Color
var _prev_fade_color: Color


func _set_fade(new_value: int) -> void:
  fade = new_value
  match fade:
    FADE.IN:
      _fade_color = FADE_IN_COLOR
      _prev_fade_color = FADE_OUT_COLOR
    FADE.OUT:
      _fade_color = FADE_OUT_COLOR
      _prev_fade_color = FADE_IN_COLOR


func next() -> void:
  step_next_began.emit()
  for targetNodePath in targetNodes:
    var targetNode = slide.get_node(targetNodePath)
    targetNode.modulate = _fade_color
  step_next_ended.emit()
  
  
func previous() -> void:
  step_previous_began.emit()
  for targetNodePath in targetNodes:
    var targetNode = slide.get_node(targetNodePath)
    targetNode.modulate = _prev_fade_color
  step_previous_ended.emit() 

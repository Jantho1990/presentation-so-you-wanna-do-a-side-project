class_name SlideStep
extends Resource

signal slide_set
signal step_next_began
signal step_next_ended
signal step_previous_began
signal step_previous_ended


@export var animation_duration : float = 0.5

var in_progress := false
var slide : PresentationSlide : set = _set_slide


func _init() -> void:
  step_next_began.connect(_on_Step_next_began)
  step_next_ended.connect(_on_Step_next_ended)
  step_previous_began.connect(_on_Step_previous_began)
  step_previous_ended.connect(_on_Step_previous_ended)


func _on_Step_next_began() -> void:
  in_progress = true


func _on_Step_next_ended() -> void:
  in_progress = false


func _on_Step_previous_began() -> void:
  in_progress = true


func _on_Step_previous_ended() -> void:
  in_progress = false
  
  
# Runs when the slide moves to the next step.
# Interface function. Must be replaced by inhereting resources.
func next() -> void:
#  step_next_began.emit()
#  step_next_ended.emit()
  pass
  
  
# Runs when the slide moves to the previous step.
# Interface function. Must be replaced by inhereting resources.  
func previous() -> void:
#  step_previous_began.emit()
#  step_previous_ended.emit()
  pass


func _set_slide(value: PresentationSlide) -> void:
  slide = value
  slide_set.emit()

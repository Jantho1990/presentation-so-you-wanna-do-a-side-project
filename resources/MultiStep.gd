class_name MultiStep
extends SlideStep

signal next_requested
signal previous_requested

@export var slide_steps : Array[SlideStep] : set = _set_slide_steps


func _on_SlideStep_next_requested() -> void:
  next_requested.emit()


func _on_SlideStep_previous_requested() -> void:
  previous_requested.emit()


func _set_slide_steps(value: Array) -> void:
  if slide_steps:
    for slideStep in slide_steps:
      if slideStep.has_signal("next_requested"):
        slideStep.next_requested.disconnect(_on_SlideStep_next_requested)
      if slideStep.has_signal("previous_requested"):
        slideStep.previous_requested.disconnect(_on_SlideStep_previous_requested)
    
  slide_steps = value
  if not slide:
    await slide_set
  for slideStep in slide_steps:
    slideStep.slide = slide
    if slideStep.has_signal("next_requested"):
      slideStep.next_requested.connect(_on_SlideStep_next_requested)
    if slideStep.has_signal("previous_requested"):
      slideStep.previous_requested.connect(_on_SlideStep_previous_requested)


# Runs when the slide moves to the next step.
func next() -> void:
  step_next_began.emit()
  for slideStep in slide_steps:
    slideStep.next()
    if slideStep.in_progress:
      await slideStep.step_next_ended
  step_next_ended.emit()

  
# Runs when the slide moves to the previous step.
func previous() -> void:
  step_previous_began.emit()
  var inverted_steps = slide_steps.duplicate()
  inverted_steps.reverse()
  for slideStep in inverted_steps:
    slideStep.previous()
    if slideStep.in_progress:
      await slideStep.step_previous_ended
  step_previous_ended.emit()

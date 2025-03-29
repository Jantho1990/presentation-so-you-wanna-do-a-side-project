class_name WaitStep
extends SlideStep


# Runs when the slide moves to the next step.
func next() -> void:
  step_next_began.emit()
  await slide.get_tree().create_timer(animation_duration).timeout
  step_next_ended.emit()
  
  
# Runs when the slide moves to the previous step.
func previous() -> void:
  step_previous_began.emit()
  await slide.get_tree().create_timer(animation_duration).timeout
  step_previous_ended.emit()

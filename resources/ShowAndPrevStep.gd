class_name ShowAndPrevStep
extends AutoAdvanceStep


# Runs when the slide moves to the next step.
# Interface function. Must be replaced by inhereting resources.
func next() -> void:
  step_next_began.emit()
  slide.show()
  step_next_ended.emit()
  
  
# Runs when the slide moves to the previous step.
# Interface function. Must be replaced by inhereting resources.  
func previous() -> void:
  step_previous_began.emit()
  slide.hide()
  previous_requested.emit()
  step_previous_ended.emit()

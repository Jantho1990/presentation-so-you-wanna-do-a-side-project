class_name HideAndNextStep
extends AutoAdvanceStep


# Runs when the slide moves to the next step.
func next() -> void:
  step_next_began.emit()
  slide.hide()
  super()
  step_next_ended.emit()
  print('DBG: hide and next done')
  
  
# Runs when the slide moves to the previous step.
func previous() -> void:
  step_previous_began.emit()
  slide.show()
#  super() # NO! This will mess up signals and visuals.
  step_previous_ended.emit()

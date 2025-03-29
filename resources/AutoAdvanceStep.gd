class_name AutoAdvanceStep
extends SlideStep

signal next_requested
signal previous_requested


# Runs when the slide moves to the next step.
# Interface function. Must be replaced by inhereting resources.
func next() -> void:
  emit_signal("next_requested")
  
  
# Runs when the slide moves to the previous step.
# Interface function. Must be replaced by inhereting resources.  
func previous() -> void:
  emit_signal("previous_requested")

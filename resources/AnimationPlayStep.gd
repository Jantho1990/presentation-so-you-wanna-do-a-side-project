class_name AnimationPlayStep
extends SlideStep


@export var animationPlayerPath: NodePath : set = _set_animationPlayerPath
@export var animation_name: String

var _animationPlayer


func _set_animationPlayerPath(value: NodePath) -> void:
  animationPlayerPath = value
  if not slide:
    await slide_set
    await slide.ready
  _animationPlayer = slide.get_node(animationPlayerPath)


# Runs when the slide moves to the next step.
# Interface function. Must be replaced by inhereting resources.
func next() -> void:
  step_next_began.emit()
  if _animationPlayer.is_playing():
    _animationPlayer.stop()
  _animationPlayer.play(animation_name)
  await _animationPlayer.animation_finished
  step_next_ended.emit()
  
  
# Runs when the slide moves to the previous step.
# Interface function. Must be replaced by inhereting resources.  
func previous() -> void:
  step_previous_began.emit()
  if _animationPlayer.is_playing():
    _animationPlayer.stop()
  _animationPlayer.play_backwards(animation_name)
  await _animationPlayer.animation_finished
  step_previous_ended.emit()

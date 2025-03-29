class_name PresentationSlide
extends Control

signal finished
signal finish_reversed
signal started


@export var steps : Array[SlideStep] : set = _set_steps
@export var step := 0 # The current step this slide is on.
@export_range(1, 9999) var total_steps := 1

var currentStep : SlideStep


func on_SlideStep_next_requested(requestingSlideStep: SlideStep) -> void:
  next()
  
  
func on_SlideStep_previous_requested(requestingSlideStep: SlideStep) -> void:
  previous()


func _set_steps(value: Array) -> void:
  steps = value
  for slideStep in steps:
    slideStep.slide = self
    _connect_slide_signals(slideStep)


func _connect_slide_signals(slideStep: SlideStep) -> void:
  if slideStep.has_signal('next_requested'):
    slideStep.next_requested.connect(on_SlideStep_next_requested.bind(slideStep))
  if slideStep.has_signal('previous_requested'):
    slideStep.previous_requested.connect(on_SlideStep_previous_requested.bind(slideStep))


func _finish() -> void:
  emit_signal("finished")


func _finish_reverse() -> void:
  emit_signal("finish_reversed")


func finish() -> void:
  _finish()


func next() -> void:
  if step == steps.size():
    _finish()
    return
  
  currentStep = steps[step]
  step += 1
  currentStep.next()
  
  
func previous() -> void:
  if step == 0:
    _finish_reverse()
    return
  
  step -= 1
  currentStep = steps[step]
  currentStep.previous()

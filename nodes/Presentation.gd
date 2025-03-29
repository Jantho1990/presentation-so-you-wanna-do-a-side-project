class_name Presentation
extends Control

signal finished


@export var close_on_finish := true

var currentSlide : PresentationSlide
var slides: Array[PresentationSlide] : get = _get_slides


func _on_SlideNode_finished() -> void:
#  if currentSlide.get_index() == get_child_count() - 1:
#    return
  
  _deactivate_slide(currentSlide)
  if currentSlide.get_index() == self.slides.size() - 1:
    if close_on_finish:
      _finish()
    return
  currentSlide = self.slides[currentSlide.get_index() + 1]
  _activate_slide(currentSlide)
  currentSlide.next()


func _on_SlideNode_finish_reversed() -> void:
  if currentSlide.get_index() == 0:
    return
  
  _deactivate_slide(currentSlide)  
  currentSlide = self.slides[currentSlide.get_index() - 1]
  _activate_slide(currentSlide)
  currentSlide.previous()


func _get_slides() -> Array:
  return get_children()


func _activate_slide(slideNode: PresentationSlide) -> void:
  slideNode.finished.connect(_on_SlideNode_finished)
  slideNode.finish_reversed.connect(_on_SlideNode_finish_reversed)


func _deactivate_slide(slideNode: PresentationSlide) -> void:
  slideNode.finished.disconnect(_on_SlideNode_finished)
  slideNode.finish_reversed.disconnect(_on_SlideNode_finish_reversed)


func _finish() -> void:
  currentSlide = null
  emit_signal("finished")


func next() -> void:
  if not currentSlide:
    return
  currentSlide.next()
  

func previous() -> void:
  if not currentSlide:
    return
  currentSlide.previous()
  
  
func start() -> void:
  if not get_child_count() > 0:
    await ready
  currentSlide = self.slides[0]
  _activate_slide(currentSlide)
  currentSlide.next()

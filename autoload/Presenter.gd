extends Node


@export var activePresentation : Presentation


# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass


func _input(_inputEvent: InputEvent) -> void:
  if not activePresentation:
    return
  
  if Input.is_action_just_pressed("slide_step_next"):
    activePresentation.next()
  elif Input.is_action_just_pressed("slide_step_prev"):
    activePresentation.previous()
  elif Input.is_action_just_pressed("slide_next"):
    pass
  elif Input.is_action_just_pressed("slide_prev"):
    pass
  elif Input.is_action_just_pressed("slide_reset"):
    pass
  elif Input.is_action_just_pressed("slide_restart"):
    pass


func _on_ActivePresentation_finished() -> void:
  activePresentation.hide()
  activePresentation = null


func activate_presentation(presentationNode: Presentation) -> void:
  activePresentation = presentationNode
  activePresentation.finished.connect(_on_ActivePresentation_finished)
  

func start_presentation() -> void:
  if not activePresentation:
    return
    
  activePresentation.show()
  activePresentation.start()

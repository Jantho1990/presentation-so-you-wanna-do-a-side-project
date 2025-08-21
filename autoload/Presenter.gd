extends Node


const DEBOUNCE_DURATION = 0.15

@export var activePresentation : Presentation

var _debouncing := false

@onready var _debounceTimer = Timer.new()


# Called when the node enters the scene tree for the first time.
func _ready():
  _set_up_debounce_timer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass


func _input(_inputEvent: InputEvent) -> void:
  if not activePresentation or _debouncing:
    return
  
  if Input.is_action_just_pressed("slide_step_next"):
    activePresentation.next()
    _debounce()
  elif Input.is_action_just_pressed("slide_step_prev"):
    activePresentation.previous()
    _debounce()
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


func _on_DebounceTimer_timeout() -> void:
  _debouncing = false


func _debounce() -> void:
  _debouncing = true
  _debounceTimer.start(DEBOUNCE_DURATION)


func _set_up_debounce_timer() -> void:
  _debounceTimer.one_shot = true
  add_child(_debounceTimer)
  _debounceTimer.timeout.connect(_on_DebounceTimer_timeout)


# Makes the presentation ready for use.
func activate_presentation(presentationNode: Presentation) -> void:
  activePresentation = presentationNode
  activePresentation.finished.connect(_on_ActivePresentation_finished)
  

# Starts the active presentation.
func start_presentation() -> void:
  if not activePresentation:
    return
    
  activePresentation.show()
  activePresentation.start()

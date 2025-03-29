extends Control


@onready var test0Presentation = $StopWaitingForGodotPresentation


# Called when the node enters the scene tree for the first time.
func _ready():
  Presenter.activate_presentation(test0Presentation)
  Presenter.start_presentation()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  pass

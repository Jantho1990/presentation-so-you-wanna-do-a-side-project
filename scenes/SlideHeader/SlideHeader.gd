@tool
extends VBoxContainer


@export var title := 'Your Slide Title!': set = _set_title

@onready var _slideHeaderLabel: RichTextLabel = $Indent/SlideHeader


func _set_title(new_value: String) -> void:
  title = new_value
  
  # TODO: Figure out why this works when editing from the tool script,
  # but not when initially setting the property.
  if not _slideHeaderLabel:
    await ready
  
  _slideHeaderLabel.text = '[b]%s[/b]' % title

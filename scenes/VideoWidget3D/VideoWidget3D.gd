extends Node3D


@export var videoStreamResource: Resource : set = _set_videoStreamResource

@onready var subViewport = $SubViewport
@onready var videoStreamPlayer = $SubViewport/Control/VideoStreamPlayer


func _ready() -> void:
  subViewport.transparent_bg = true


func _on_VideoStreamPlayer_finished() -> void:
  videoStreamPlayer.play()


func _set_videoStreamResource(value: Resource) -> void:
  if videoStreamResource:
    videoStreamResource.finished.disconnect(_on_VideoStreamPlayer_finished)
  videoStreamResource = value
  if not videoStreamPlayer:
    await ready
  videoStreamPlayer.stream = videoStreamResource
  videoStreamPlayer.finished.connect(_on_VideoStreamPlayer_finished)
  videoStreamPlayer.play()
  

extends Control


@onready var animationPlayer = $AnimationPlayer


func animate_title_in() -> void:
  animationPlayer.play('lines_in')
  
  
func animate_title_out() -> void:
  animationPlayer.play('lines_out')

extends CharacterBody3D


@export var base_speed = 5
@export var sprint_speed = 8
@export var jump_velocity = 4
@export var sensitivity = 0.1
@export var accel = 10
@export var use_gravity := true
@export var look_at_target : Vector3 : set = _set_look_at_target
@export var freeze := false : set = _set_freeze
var speed = base_speed
var sprinting = false
var camera_fov_extents = [75.0, 85.0] #index 0 is normal, index 1 is sprinting


@onready var parts = {
  "head": $head,
  "camera": $head/camera,
  "camera_animation": $head/camera/camera_animation
}
@onready var world = get_parent()

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


#func _ready():
#  parts.camera.current = true

func _process(delta):
  if Input.is_action_pressed("move_sprint"):
    sprinting = true
    speed = sprint_speed
    parts.camera.fov = lerp(parts.camera.fov, camera_fov_extents[1], 10*delta)
  else:
    sprinting = false
    speed = base_speed
    parts.camera.fov = lerp(parts.camera.fov, camera_fov_extents[0], 10*delta)

func _physics_process(delta):
  if use_gravity and not is_on_floor():
    velocity.y -= gravity * delta

  if Input.is_action_pressed("move_jump") and is_on_floor():
    velocity.y += jump_velocity

  var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
  var direction = input_dir.normalized().rotated(-parts.head.rotation.y)
  direction = Vector3(direction.x, 0, direction.y)
  velocity.x = lerp(velocity.x, direction.x * speed, accel * delta)
  velocity.z = lerp(velocity.z, direction.z * speed, accel * delta)
#  if is_on_floor(): #don't lerp y movement
#    velocity.x = lerp(velocity.x, direction.x * speed, accel * delta)
#    velocity.z = lerp(velocity.z, direction.z * speed, accel * delta)
  
  #bob head
  if input_dir and is_on_floor():
    parts.camera_animation.play("head_bob", 0.5)
  else:
    parts.camera_animation.play("reset", 0.5)

  move_and_slide()
  
  if _is_joypad_right_stick():
    _look_with_joypad_right_stick()

func _input(event):
  if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
    parts.head.rotation_degrees.y -= event.relative.x * sensitivity
    parts.head.rotation_degrees.x -= event.relative.y * sensitivity
    parts.head.rotation.x = clamp(parts.head.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _set_look_at_target(value: Vector3) -> void:
  look_at_target = value
  if not parts:
    await ready
  parts.head.look_at(look_at_target)
#  parts.head.rotation_degrees.y -= event.relative.x * sensitivity
#  parts.head.rotation_degrees.x -= event.relative.y * sensitivity
#  parts.head.rotation.x = clamp(parts.head.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _set_freeze(value: bool) -> void:
  freeze = value
  if not parts: # Can't stop process funcs before ready, so this is a cheap hack to make sure we wait for that.
    await ready
  set_physics_process(!freeze)
  set_process(!freeze)
  set_process_input(!freeze)

func _look_with_joypad_right_stick() -> void:
  parts.head.rotation_degrees.y -= Input.get_axis("look_left", "look_right") * 30 * sensitivity
  parts.head.rotation_degrees.x -= Input.get_axis("look_up", "look_down") * 30 * sensitivity
  parts.head.rotation.x = clamp(parts.head.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _is_joypad_right_stick() -> bool:
  return Input.is_action_pressed("look_down") or Input.is_action_pressed("look_left") or Input.is_action_pressed("look_right") or Input.is_action_pressed("look_up")

func _on_pause():
  pass

func _on_unpause():
  pass

extends Camera3D

@export var use_auto := false

# Quad mesh position
var quad_mesh_position = Vector3(0, 7.309, -8.559)  # Replace with the actual position of your quad mesh
var quad_mesh_width = 21.333  # Replace with the width of your quad mesh
var quad_mesh_height = 12     # Replace with the height of your quad mesh

# Focal length of the camera
var focal_length = 107.51  # 107.51 = 1920x1080

# Adjust this value to control the zoom level
var zoom_factor = 1.0  # Increase for zoom in, decrease for zoom out

#var _pos = Vector3(0, 7.309, -5.257)
var _pos = Vector3(0, 7.309, -5.261)


# Called when the node enters the scene tree for the first time.
func _ready():
  if not fov == focal_length:
    fov = focal_length
  if use_auto:
    _reposition_camera4()


func _animate_to_target(target_position: Vector3) -> void:
  pass


func _reposition_camera() -> void:
  # Calculate the horizontal and vertical angles
    var horizontal_angle = 2 * atan(quad_mesh_width / (2 * focal_length))
    var vertical_angle = 2 * atan(quad_mesh_height / (2 * focal_length))

    # Calculate the distance from the camera to the quad mesh
    var distance = (quad_mesh_width / 2) / tan(horizontal_angle / 2)

    # Calculate the camera's position
    var camera_position = quad_mesh_position - transform.basis.z * distance

    # Set the camera's position
    transform.origin = camera_position


func _reposition_camera2():
    # Calculate the camera's position based on viewport dimensions
    var viewport_size = get_tree().root.get_visible_rect().size
    var aspect_ratio = viewport_size.x / viewport_size.y

    var camera_position = quad_mesh_position
    camera_position.x = quad_mesh_width / 2
    camera_position.y = -quad_mesh_height / 2 / aspect_ratio

    # Set the camera's position
    transform.origin = camera_position

func _reposition_camera3():
    # Get the viewport size
    var viewport_size = get_tree().root.get_visible_rect().size

    # Calculate the camera's position to frame the quad mesh
    var camera_position = quad_mesh_position

    # Calculate the position so that the quad mesh exactly fills the screen
    camera_position.z = quad_mesh_height / (2.0 * tan(deg_to_rad(fov / 2.0)))
    camera_position.x = quad_mesh_position.x
    camera_position.y = quad_mesh_position.y - (camera_position.z * viewport_size.y / quad_mesh_height)

    # Set the camera's position
    transform.origin = camera_position


func _reposition_camera4():
    # Calculate the horizontal and vertical FOV in radians
    var horizontal_fov = deg_to_rad(fov)
    var vertical_fov = horizontal_fov * (quad_mesh_height / quad_mesh_width)

    # Calculate the distance from the camera to the quad mesh (zoom in)
    var desired_width = quad_mesh_width  # You can adjust this for zoom level
    var distance = (desired_width / 2) / tan(horizontal_fov / 2)

    # Calculate the camera's position
    var camera_position = quad_mesh_position - transform.basis.z * distance

    # Set the camera's position
    transform.origin = camera_position

func _reposition_camera5():
    # Calculate the camera's position
    var viewport_size = get_tree().root.get_visible_rect().size
    var aspect_ratio = viewport_size.x / viewport_size.y
    var horizontal_fov = 2 * atan(quad_mesh_width / (2 * zoom_factor))  # Adjust the zoom_factor
    var vertical_fov = horizontal_fov / aspect_ratio

    var distance = (quad_mesh_width / 2) / tan(horizontal_fov / 2)

    var camera_position = quad_mesh_position - transform.basis.z * distance

    # Set the camera's position and FOV
    transform.origin = camera_position
    fov = rad_to_deg(horizontal_fov)

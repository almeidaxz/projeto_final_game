extends Camera3D

@onready var golf_ball = $".."

const ray_length = 100
var mouse_pos : Vector2
var from : Vector3
var to : Vector3
var space : PhysicsDirectSpaceState3D
var query : PhysicsRayQueryParameters3D

var vector : Vector3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.set_as_top_level(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera_follow()
	
func camera_follow():
	vector = Vector3(golf_ball.transform.origin.x, position.y, golf_ball.transform.origin.z)
	self.transform.origin = self.transform.origin.lerp(vector, 1)

func camera_raycast():
	mouse_pos = get_viewport().get_mouse_position()
	from = project_ray_origin(mouse_pos)
	to = from + project_ray_normal(mouse_pos) * ray_length
	space = get_world_3d().direct_space_state
	query = PhysicsRayQueryParameters3D.create(from, to, 2)
	return space.intersect_ray(query)

extends RigidBody3D

@export var max_speed : int = 8
@export var accel : int = 5

@onready var scaler = $Scaler
@onready var camera_3d = $Camera3D

var selected : bool = false
var velocity : Vector3
var speed : Vector3
var distance : float
var direction : Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scaler.set_as_top_level(true)
	pass
	
func _on_input_event(camera, event, position, normal, shape_idx) -> void:
	if event.is_action_pressed("click"):
		selected = true

func _input(event) -> void:
	if event.is_action_released("left_mb"):
		if selected:
			speed = - (direction * distance * accel).limit_length(max_speed)
			shoot(speed)
		selected = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	scaler_follow()
	pull_metter()

func shoot(vector: Vector3) -> void:
	velocity = Vector3(vector.x, 0, vector.z)
	self.apply_impulse(velocity, Vector3.ZERO)

func scaler_follow() -> void:
	scaler.transform.origin = scaler.transform.origin.lerp(self.transform.origin, .8)
	

func pull_metter() -> void:
	var ray_cast = camera_3d.camera_raycast()
	if not ray_cast.is_empty():
		distance = self.position.distance_to(ray_cast.position)
		direction = self.transform.origin.direction_to(ray_cast.position)
		scaler.look_at(Vector3(ray_cast.position.x, position.y, ray_cast.position.z))
		
		if selected:
			scaler.scale.z = clamp(distance, 0, 2)
		else:
			scaler.scale.z = 0.01
		

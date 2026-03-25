extends CharacterBody3D
class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var camera: Camera3D = $Camera3D
@onready var ray: RayCast3D = $Camera3D/RayCast3D


var look_dir : Vector2 
var camera_sens = 50
var cap_mouse = false

signal looking_at_cam
signal not_looking_at_cam
func _physics_process(delta: float) -> void:
	
	if _check_for_cam():
		#print("looking at camera")
		emit_signal("looking_at_cam")
	else:
		emit_signal("not_looking_at_cam")
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if Input.is_action_just_pressed("pause"):
		cap_mouse = !cap_mouse
		
		if cap_mouse:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if camera.current:
		_rotate_camera(delta)
		move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_dir = event.relative * 0.01
		
func _rotate_camera(delta:float, sens_mod:float = 1.0):
	#var input = Input.get_vector("look_left","look_right","look_down","look_up")
	#look_dir += input
	rotation.y -= look_dir.x * camera_sens * delta
	camera.rotation.x = clamp(camera.rotation.x - look_dir.y * camera_sens * sens_mod * delta, -1.5, 1.5)
	look_dir = Vector2.ZERO
	
func _check_for_cam() -> float:
	if ray.get_collider() != null:
		if ray.get_collider().is_in_group("cams"):
			return true
		else:
			return false
	return false

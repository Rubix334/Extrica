extends CharacterBody3D
class_name Player

var SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var camera: Camera3D = $Camera3D
@onready var ray: RayCast3D = $Camera3D/RayCast3D
@onready var collision: CollisionShape3D = $CollisionShape3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var look_dir : Vector2 
var camera_sens = 50
var cap_mouse = false
var crouched = false
var sprinting = false

signal looking_at_cam
signal not_looking_at_cam
func _physics_process(delta: float) -> void:
	
	if _check_for_cam():
		#print("looking at camera")
		emit_signal("looking_at_cam")
	else:
		emit_signal("not_looking_at_cam")
	
	##sprinting
	if not crouched:
		if Input.is_action_pressed("sprint"):
			SPEED = 10
			sprinting = true
		if Input.is_action_just_released("sprint"):
			SPEED = 5.0
			sprinting = false

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		head_bob()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	##remove cursor
	if Input.is_action_just_pressed("pause"):
		cap_mouse = !cap_mouse
		
		if cap_mouse:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	#only move when in player POV
	if camera.current:
		crouch()
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

func crouch():
	if Input.is_action_just_pressed("crouch"):
		if not crouched:
			SPEED = 2.5
			camera.position.y -= 1
			collision.shape.height = 1
			collision.position.y -= 0.5
			crouched = true
		else:
			SPEED = 5.0
			camera.position.y += 1
			collision.shape.height = 2
			collision.position.y += 0.5
			crouched = false

func head_bob():
	animation_player.play("bob")
	if not sprinting:
		animation_player.speed_scale = 1
	else:
		animation_player.speed_scale = 1.5

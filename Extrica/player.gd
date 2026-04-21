extends CharacterBody3D
class_name Player

@export var SPEED := 5.0
var speed = SPEED
var S_SPEED = (SPEED * 2)-2
var C_SPEED = SPEED / 2
@export var camera_sens = 50

const JUMP_VELOCITY = 4.5
@onready var camera: Camera3D = $Camera3D
@onready var ray: RayCast3D = $Camera3D/RayCast3D
@onready var collision: CollisionShape3D = $CollisionShape3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_audio: AudioStreamPlayer3D = $PlayerAudio

var accepting_input = true

var look_dir : Vector2 
var cap_mouse = false
var crouched = false
var sprinting = false

var moving = false

signal looking_at_cam
signal not_looking_at_cam
func _ready() -> void:
	#Global.connect("playerCaught",caught)
	pass

func _physics_process(delta: float) -> void:
	
	#cam switch
	if _check_for_cam():
		#print("looking at camera")
		emit_signal("looking_at_cam")
	else:
		emit_signal("not_looking_at_cam")
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	##remove cursor
	if Input.is_action_just_pressed("pause"):
		cap_mouse = !cap_mouse
		
		if cap_mouse:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if accepting_input:
		##sprinting
		if not crouched:
			if Input.is_action_pressed("sprint"):
				SPEED = S_SPEED
				sprinting = true
			if Input.is_action_just_released("sprint"):
				SPEED = speed
				sprinting = false



		# Get the input direction and handle the movement/deceleration.
		var input_dir := Input.get_vector("left", "right", "forward", "back")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			player_audio.process_mode = Node.PROCESS_MODE_INHERIT
			if camera.current:
				head_bob()
				
		else:
			player_audio.process_mode = Node.PROCESS_MODE_DISABLED
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		#only move when in player POV
		if camera.current:
			crouch()
			_rotate_camera(delta)
			move_and_slide()
			$Crosshair.visible = true
		else:
			$Crosshair.visible = false

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
			animation_player.stop()
			SPEED = C_SPEED
			camera.position.y -= 1
			collision.shape.height = 1.3
			collision.position.y -= 0.3
			crouched = true
		else:
			animation_player.stop()
			SPEED = speed
			camera.position.y += 1
			collision.shape.height = 2
			collision.position.y += 0.3
			crouched = false

func head_bob():
	if not crouched:
		animation_player.play("bob")
		if not sprinting:
			animation_player.speed_scale = 1
		else:
			animation_player.speed_scale = 1.5
	else:
		animation_player.play("crouchbob")

func caught(enemy:Enemy):
	accepting_input = false
	var to_enemy = (enemy.global_transform.origin - global_transform.origin).normalized()
	var new_dir = global_position.slerp(to_enemy, 0.2).normalized()
	camera.look_at(camera.global_transform.origin + new_dir, Vector3.UP)

extends CharacterBody3D
class_name Player
@onready var game_over_hud: Control = $GameOverHud

@export var SPEED := 5.0
var speed = SPEED
var S_SPEED = (SPEED * 2)-2
var C_SPEED = SPEED / 2
@export var camera_sens : float = 50.0

const JUMP_VELOCITY = 4.5
@onready var camera: Camera3D = $Camera3D
@onready var ray: RayCast3D = $Camera3D/RayCast3D
@onready var collision: CollisionShape3D = $CollisionShape3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_audio: AudioStreamPlayer3D = $PlayerAudio
@onready var audio_emission_area: Area3D = $AudioEmissionArea
@onready var audio_emission_shape: CollisionShape3D = $AudioEmissionArea/CollisionShape3D
@onready var player_hud: Control = $player_hud

var accepting_input = true

var look_dir : Vector2 
var cap_mouse = false
var crouched = false
var sprinting = false

var moving = false

#signal looking_at_cam
signal not_looking_at_cam
func _ready() -> void:
	#Global.connect("playerCaught",caught)
	pass

func _physics_process(delta: float) -> void:
	
	#cam switch
	if _check_for_cam():
		#print("looking at camera")
		#emit_signal("looking_at_cam")
		var cam = _get_object_in_view()
		cam._looked_at()
		player_hud.label.visible=true
	else:
		emit_signal("not_looking_at_cam")
		player_hud.label.visible=false
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
				audio_emission_shape.shape.radius = 5
				SPEED = S_SPEED
				sprinting = true
			if Input.is_action_just_released("sprint"):
				audio_emission_shape.shape.radius = 2.5
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

func _get_object_in_view() -> Object:
	return ray.get_collider()

func crouch():
	if Input.is_action_just_pressed("crouch"):
		if not crouched:
			animation_player.stop()
			SPEED = C_SPEED
			camera.position.y = -0.7 #-= 1
			collision.shape.height = 1.3
			collision.position.y = -0.3
			crouched = true
		else:
			animation_player.stop()
			audio_emission_shape.shape.radius = 0.01
			SPEED = speed
			camera.position.y = 0.3 #+= 1
			collision.shape.height = 2
			collision.position.y = 0 #+= 0.3
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
	var angle = atan2(global_position.x - enemy.global_position.x,global_position.y - enemy.global_position.y)
	camera.make_current()
	rotate_camera_to(angle)
	game_over_hud.visible = true
	Global.death = true

func rotate_camera_to(new_angle: float):

	var tween = create_tween()
	# "rotation:y" targets the specific property
	tween.tween_property(self, "rotation:y", new_angle, 0.5).set_trans(Tween.TRANS_SINE)

func play_animation(animation:String):
	animation_player.play(animation)


func _on_audio_emission_area_body_entered(body: Node3D) -> void:
	if body is Enemy:
		body.hear_noise(global_position)

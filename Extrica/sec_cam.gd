extends Node3D
class_name sec_cam
var look_dir : Vector2 
var camera_sens = player.camera_sens
@export var player:Player
@onready var body: MeshInstance3D = $MeshInstance3D
@onready var camera: Camera3D = $Camera3D

var switchable:bool
var controlled:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.connect("looking_at_cam", _looked_at)
	player.connect("not_looking_at_cam",_not_looked_at)
	switchable = false
	controlled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if switchable:
		if Input.is_action_just_pressed("hack"): #hack = Q
			camera.make_current()
			controlled = true
	
	
	pass

func _looked_at():
	switchable = true
	body.get_surface_override_material(3).emission_enabled = true

func _not_looked_at():
	switchable = false
	body.get_surface_override_material(3).emission_enabled = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_dir = event.relative * 0.01
		
func _rotate_camera(delta:float, sens_mod:float = 1.0):
	#var input = Input.get_vector("look_left","look_right","look_down","look_up")
	#look_dir += input
	rotation.y -= look_dir.x * camera_sens * delta
	camera.rotation.x = clamp(camera.rotation.x - look_dir.y * camera_sens * sens_mod * delta, -1.5, 1.5)
	look_dir = Vector2.ZERO

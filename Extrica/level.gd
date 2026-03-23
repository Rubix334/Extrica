extends Node3D

@onready var cam: Camera3D = $Camera3D

@onready var player: CharacterBody3D = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_debug_camera()
	pass

func _debug_camera():
	if Input.is_action_just_pressed("cam_DEBUG") and !cam.is_current():
		cam.set_current(true)
	

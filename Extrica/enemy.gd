extends PathFollow3D

@onready var navi_agent: NavigationAgent3D = $NavigationAgent3D
@onready var FOV: ShapeCast3D = $ShapeCast3D

@export var navimap:NavigationRegion3D
var speed := 2

func _physics_process(delta: float) -> void:
	pass

func _process(delta: float) -> void:
	patrol(delta)
	pass

func patrol(delta:float):
	##follow path; check if player is detected
	##save current position to return to when changing states
	detect_player()
	follow_path(delta)

	
	
func hunt_player():
	##follow player;if player is out of view
	##start a timer on which timeout will call return_to_patrol()
	
	pass
func return_to_patrol():
	##player is not detected; return to last position of patrolling
	##change state to patrol
	pass

func detect_player():
	if FOV.collide_with_areas:
		print("true")
	else:
		print("false")

func follow_path(delta):
	var changeDir = false
	progress += delta * speed
	if progress_ratio > 0.99:
		speed = speed * -1
	elif progress_ratio < 0.01:
		speed = speed * -1
		

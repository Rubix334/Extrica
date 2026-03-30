extends CharacterBody3D

@onready var navi_agent: NavigationAgent3D = $NavigationAgent3D
@onready var FOV: ShapeCast3D = $ShapeCast3D

@export var navigationMap:NavigationRegion3D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		var random_position := Vector3.ZERO
		random_position.x = randf_range(-5.0,5.0)
		random_position.z = randf_range(-5.0,5.0)
		navi_agent.set_target_position(random_position)

func _physics_process(delta: float) -> void:
	patrol()
	var destination = navi_agent.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	
	velocity = direction * 5.0
	move_and_slide()


func patrol():
	##follow path; check if player is detected
	##save current position to return to when changing states
	if not FOV.collide_with_areas:
		var random_position := Vector3.ZERO
		random_position.x = randf_range(-5.0,5.0)
		random_position.z = randf_range(-5.0,5.0)
		navi_agent.set_target_position(random_position)
	else:
		print("PLAYER SPOTTED")
	
func hunt_player():
	##follow player;if player is out of view
	##start a timer on which timeout will call return_to_patrol()
	
	pass
func return_to_patrol():
	##player is not detected; return to last position of patrolling
	##change state to patrol
	pass

extends PathFollow3D

@onready var navi_agent: NavigationAgent3D = $NavigationAgent3D
@onready var fov: Area3D = $CharacterBody3D/FOV
var player_detected = false
@onready var body: CharacterBody3D = $CharacterBody3D

@export var player:Player
@export var navimap:NavigationRegion3D
var speed := 2

func _physics_process(delta: float) -> void:
	pass

func _process(delta: float) -> void:
	patrol(delta)

	body.move_and_slide()
	pass

func patrol(delta:float):
	##follow path; check if player is detected
	##save current position to return to when changing states
	var last_pos : Vector3
	if player_detected == false:
		follow_path(delta)
	else:
		last_pos = global_position
		hunt_player()

	
	
func hunt_player():
	##follow player;if player is out of view
	##start a timer on which timeout will call return_to_patrol()
	
	navi_agent.set_target_position(player.global_position)
	var destination = navi_agent.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	body.velocity = direction * speed
	look_at(direction)
	if player_detected == false:
		pass
	

func return_to_patrol():
	##player is not detected; return to last position of patrolling
	##change state to patrol
	pass



func follow_path(delta):
	var changeDir = false
	progress += delta * speed
	if progress_ratio > 0.99:
		speed = speed * -1
	elif progress_ratio < 0.01:
		speed = speed * -1
		

func detect_player(body: Node3D) -> void:
	if body is Player:
		print("Player Detected")
		player_detected = true
	else:
		player_detected = false
		print("Player out of view")

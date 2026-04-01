extends PathFollow3D

@onready var navi_agent: NavigationAgent3D = $NavigationAgent3D
@onready var fov: Area3D = $CharacterBody3D/FOV
var player_detected = false

@export var player:Player
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
	var last_pos : Vector3
	if player_detected == false:
		follow_path(delta)
	else:
		last_pos = global_position

	
	
func hunt_player():
	##follow player;if player is out of view
	##start a timer on which timeout will call return_to_patrol()
	navi_agent.set_target_position(player.global_position)
	
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
	player_detected = false

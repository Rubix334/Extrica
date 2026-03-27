extends CharacterBody3D

@onready var navi_agent: NavigationAgent3D = $NavigationAgent3D

@export var navigationMap:NavigationRegion3D

func _physics_process(delta: float) -> void:
	pass


func patrol():
	##follow path; check if player is detected
	##save current position to return to when changing states
	pass
func hunt_player():
	##follow player;if player is out of view
	##start a timer on which timeout will call return_to_patrol()
	pass
func return_to_patrol():
	##player is not detected; return to last position of patrolling
	##change state to patrol
	pass

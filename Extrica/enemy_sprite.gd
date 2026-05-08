extends AnimatedSprite3D
@onready var enemy_npc: Enemy = $".."


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	play(animation)
	var enemy_to_camera = enemy_npc.global_position - enemy_npc.player.camera.global_position 
	var enemy_z = enemy_npc.transform.basis.z
	
	var view_angle = enemy_z.signed_angle_to(enemy_to_camera, Vector3.UP)

	if view_angle < -(2*PI)/3: #5
		if enemy_npc.moving:
			play("Rightwalking")
		else:
			play("right_idle")
	elif view_angle < -PI/3: #6
		if enemy_npc.moving:
			play("Rightwalking")
		else:
			play("right_idle")
	elif view_angle < -PI/6: #7
		if enemy_npc.moving:
			play("Rightwalking")
		else:
			play("right_idle")
	elif view_angle < PI/6:#0
		if enemy_npc.moving:
			play("walking")
		else:
			play("forward_idle")
	elif view_angle < PI/3: #1
		if enemy_npc.moving:
			play("Leftwalking")
		else:
			play("left_idle")
	elif view_angle < (2*PI)/3: #2
		if enemy_npc.moving:
			play("Leftwalking")
		else:
			play("left_idle")
	elif view_angle < (5*PI)/6: #3
		if enemy_npc.moving:
			play("Leftwalking")
		else:
			play("left_idle")
	else: #4
		if enemy_npc.moving:
			play("Backwalking")
		else:
			play("back_idle")

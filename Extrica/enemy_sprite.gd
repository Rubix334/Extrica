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
	
	var view_angle = enemy_to_camera.angle_to(enemy_z)

	if abs(view_angle) > 0 and abs(view_angle) < PI/3:
		set_animation("default")
		if enemy_npc.moving:
			set_animation("walking")
	elif abs(view_angle) > PI/3 and abs(view_angle) < 2*PI/3:
		
		set_animation("Leftwalking")
	elif abs(view_angle) > 2*PI/3 and abs(view_angle) < PI:
		set_animation("Backwalking")

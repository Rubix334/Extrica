extends Node3D
@onready var enemy_npc: Enemy = $EnemyNPC
@onready var tutorial_popup: Control = $tutorial_popup

var cam_tut_read = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemy_npc.set_physics_process(false)
	tutorial_popup.animate_on_screen()
	AudioManager.play_sfx("ambient_music")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $NavigationRegion3D/outer_hallway/seccam.camera.current and cam_tut_read == false: 
		tutorial_popup.change_text("While operating a camera you have the ability to remotely hack electronics, indicated by a faint glow around specific objects. Ahead of you is a NOISEMAKER, which is able to distract enemies when they are within the radius. Press MOUSE1 on it to hack.")
		tutorial_popup.animate_on_screen()
		cam_tut_read = true


func _on_outer_hallway_area_body_entered(body: Node3D) -> void:
	if body is Player:
		print("entered")
		enemy_npc.set_physics_process(true)
		tutorial_popup.change_text("There is an enemy nearby, take cover to avoid their sight.
		 There are threats that will try to stop you in your escape. You may not be able to
		 physically fight back, but you do have tools to help you avoid them.")
		tutorial_popup.animate_on_screen()
		$outer_hallway_area.global_position = Vector3(0,0,-500)


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		print("entered")
		tutorial_popup.change_text("Look at the camera ahead to interact with it. Hold F to hack cameras. However, it is important to know that you are vunerable while operating a camera. Stay hidden!")
		tutorial_popup.animate_on_screen()
		$Area3D.global_position = Vector3(0,0,-500)


func _on_area_3d_2_body_entered(body: Node3D) -> void:
	if body is Player:
		print("entered")
		tutorial_popup.change_text("The Exit to this area is ahead. Some doors in the facility are locked. Fortunately, you are able to bypass this by hacking through a camera. Interact with the camera and press MOUSE1 to lock or unlock a selected door.")
		tutorial_popup.animate_on_screen()
		$Area3D2.global_position = Vector3(0,0,-500)


func _on_endarea_body_entered(body: Node3D) -> void:
		if body is Player:
			get_tree().change_scene_to_file("res://Level_scenes/playable_level.tscn")

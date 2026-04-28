extends Node3D

@onready var player: Player = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.camera.make_current()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_finisharea_body_entered(body: Node3D) -> void:
	if body is Player:
		get_tree().change_scene_to_file("res://temp_win.tscn")

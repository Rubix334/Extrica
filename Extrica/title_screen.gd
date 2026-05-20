extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$Label.font.size = Viewport.size.y/4
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Level_scenes/tutorial level.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()

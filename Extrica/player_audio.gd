extends AudioStreamPlayer3D
var footsteps : Array = Global.load_audio_files("res://assets/metal_steps_48k24b/")
var current_track = 0
var audio_speed = 0.3

func _ready():
	self.finished.connect(_on_finished)
	if get_parent().sprinting:
		audio_speed = 0.05
	else:
		audio_speed = 0.3
	play_next()

func play_next():
	if current_track < footsteps.size():
		await get_tree().create_timer(audio_speed).timeout
		var rand = randf_range(0,footsteps.size())
		stream = footsteps[rand]
		play()

func _on_finished():
	play_next()

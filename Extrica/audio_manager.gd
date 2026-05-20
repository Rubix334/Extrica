extends Node3D
@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

var footsteps : Array = Global.load_audio_files("res://assets/metal_steps_48k24b/")
var ambient_music = preload("res://assets/sound/07 - Intruder 2.mp3")

func _ready() -> void:
	change_vol(24,"footstep")
	
func change_vol(volume, sfx_name):
	for child in get_children():
		if child.name == sfx_name:
			child.set_volume_db(volume)

func slow_music():
	audio_player.pitch_scale = 0.5
	
func normal_music():
	audio_player.pitch_scale = 1

func fade_sound(sfx_name):
	for child in get_children():
		if child.name == sfx_name:
			while child.get_volume_db >= -79:
				child.set_volume_db(child.get_volume_db()-5)

func stop(sfx_name):
	for child in get_children():
		if child.name == sfx_name:
			child.queue_free()


#use is_playing and start() and stop() to fix sfx
func play_sfx(sfx_name : String):
	var stream = null
	
	if sfx_name == "footsteps":
		var rand = randf_range(0,footsteps.size())
		stream = footsteps[rand]
	if sfx_name == "ambient_music":
		stream = ambient_music
	else:
		print("invalid sfx name")
		return
		
	var asp = AudioStreamPlayer.new()
	asp.stream = stream
	asp.name = sfx_name
	asp.max_polyphony = 5
	add_child(asp)
	asp.play()
	
	await asp.finished
	asp.queue_free()

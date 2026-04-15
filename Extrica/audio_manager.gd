extends Node3D
@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D

var footsteps : Array = load_audio_files("res://assets/metal_steps_48k24b/")

func load_audio_files(path: String) -> Array[AudioStream]:
	var streams: Array[AudioStream] = []
	var dir = DirAccess.open(path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if not dir.current_is_dir():
				# Handling exported project remapping (stripping .import/.remap)
				var clean_path = path + "/" + file_name.replace(".import", "").replace(".remap", "")
				
				# Check for audio extensions
				if clean_path.ends_with(".wav") or clean_path.ends_with(".mp3") or clean_path.ends_with(".ogg"):
					var stream = load(clean_path)
					if stream is AudioStream:
						streams.append(stream)
			
			file_name = dir.get_next()
			
	return streams

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

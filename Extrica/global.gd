extends Node

var spotted := 0

var death = false
#signal playerCaught
var enemy_array : Array = []

func load_file_to_array(path: String) -> Array:
	var content_array = []
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		while not file.eof_reached():
			var line = file.get_line()
			content_array.append(line)
		file.close()
	return content_array

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

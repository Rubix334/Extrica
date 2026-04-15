extends Node

var spotted := 0



func load_file_to_array(path: String) -> Array:
	var content_array = []
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		while not file.eof_reached():
			var line = file.get_line()
			content_array.append(line)
		file.close()
	return content_array

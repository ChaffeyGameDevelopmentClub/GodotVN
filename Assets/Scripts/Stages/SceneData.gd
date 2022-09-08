extends Node
var scene_data = []

var json_serializer

func write(data):
	scene_data.append(data)
	print(to_json(scene_data))
	

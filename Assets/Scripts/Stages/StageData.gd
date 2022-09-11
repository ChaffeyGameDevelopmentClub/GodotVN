extends Node
var scene_data = []

signal saves_updated

var dir = Directory.new()

var save_state_dict = {
	"date" : "",
	"time" : "",
	"current_stage": "",
	"current_event": 0,
	"choice_data": []
}

func write_choice():
	pass

func save_game(slot_number, current_stage, current_event):
	save_state_dict["date"] = Time.get_date_dict_from_system()
	save_state_dict["time"] = Time.get_time_dict_from_system()
	save_state_dict["current_stage"] = current_stage
	save_state_dict["current_event"] = current_event
	var save_data = File.new()
	save_data.open("user://SaveSlot_" + str(slot_number) +".save", File.WRITE)
	save_data.store_line(to_json(save_state_dict))
	save_data.close()
	emit_signal("saves_updated")
	
func load_game(slot_number):
	var save_data = File.new()
	if not save_data.file_exists("user://SaveSlot_" + str(slot_number) +".save"):
		return #Data does not exist
	save_data.open("user://SaveSlot_" + str(slot_number) +".save", File.READ)
	save_state_dict = parse_json(save_data.get_line())

func delete_game(slot_number):
	dir.remove("user://SaveSlot_" + str(slot_number) +".save")
	emit_signal("saves_updated")
	

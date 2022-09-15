extends Node

signal saves_updated

var dir = Directory.new()

var save_state_dict = {
	"date" : "",
	"time" : "",
	"current_stage": "",
	"current_event": 0,
	"choice_data": {}
}

#Record choices for a specific stage
func write_choice(stage_name, choices):
	save_state_dict["choice_data"][str(stage_name)] = choices
	
func get_stage_choices(stage_name):
	print(stage_name)
	print(save_state_dict)
	
	if stage_name in save_state_dict["choice_data"]:
		return  save_state_dict["choice_data"][stage_name]

#Write to a save slot
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
	
#Load data from a save slot
func load_game(slot_number):
	var save_data = File.new()
	if not save_data.file_exists("user://SaveSlot_" + str(slot_number) +".save"):
		return #Data does not exist
	save_data.open("user://SaveSlot_" + str(slot_number) +".save", File.READ)
	save_state_dict = parse_json(save_data.get_line())
	print(str(save_state_dict))

#Delete a save slot
func delete_game(slot_number):
	dir.remove("user://SaveSlot_" + str(slot_number) +".save")
	emit_signal("saves_updated")
	

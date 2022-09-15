extends ItemList


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var StageData = null


# Called when the node enters the scene tree for the first time.
func _ready():
	StageData = get_node("/root/StageData")
	StageData.connect("saves_updated", self, "on_saves_updated")
	for i in range(99):
		self.add_item("SaveSlot " + str(i+1), null, true)
		var save_data = File.new()
		if save_data.file_exists("user://SaveSlot_" + str(i+1) +".save"):
			self.set_item_text(i, "SaveSlot_" + str(i+1) + " [Written]")
	

func update_slot_indices():
	self.clear()
	for i in range(99):
		self.add_item("SaveSlot " + str(i+1), null, true)
		var save_data = File.new()
		if save_data.file_exists("user://SaveSlot_" + str(i+1) +".save"):
			self.set_item_text(i, "SaveSlot_" + str(i+1) + " [Written]")

func on_saves_updated():
	update_slot_indices()

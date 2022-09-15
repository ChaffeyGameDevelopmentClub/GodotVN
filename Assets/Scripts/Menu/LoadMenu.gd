extends Node2D


onready var saveslots = $SaveSlots
var selected_slot_index = 0

signal load_save
signal delete_save
signal menu_closed

# Called when the node enters the scene tree for the first time.
func _ready():
	saveslots.select(0, true)
	selected_slot_index = 1

func _on_SaveSlots_item_selected(index):
	selected_slot_index = index+1

func _on_Delete_pressed():
	emit_signal("delete_save", selected_slot_index)
	saveslots.update_slot_indices()

func _on_Load_pressed():
	emit_signal("load_save", selected_slot_index)
	saveslots.update_slot_indices()

func _on_Back_pressed():
	self.visible = false
	emit_signal("menu_closed")
	


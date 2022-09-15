extends Node2D

signal start_game

onready var loadmenu = $LoadMenu
onready var options_menu = null
signal delete_Save
signal load_save

func _on_Start_button_down():
	emit_signal("start_game")

func _on_Load_button_down():
	loadmenu.visible = true

func _on_Options_button_down():
	pass # Open options

func _on_Exit_button_down():
	get_tree().quit()
	
func _on_Menu_load_save(slot_number):
	StageData.load_game(slot_number)
	var current_stage = Stage.STAGE_PATHS[StageData.save_state_dict["current_stage"]]
	var current_event = StageData.save_state_dict["current_event"]
	var parent = get_parent()
	parent.current_stage = load(current_stage).instance()
	parent.add_child(parent.current_stage)
	parent.current_stage.load_stage_state(current_event)
	self.queue_free()

func _on_Menu_delete_save(slot_number):
	StageData.delete_game(slot_number)

extends Node2D

class_name Stage

onready var MusicPlayer = $MusicPlayer
onready var SFXPlayer = $SFXPlayer
onready var Setting = $Setting #Background
onready var Actors = $Actors
onready var ChoiceBox = $ChoiceBox
onready var Dialog = $Dialog
export var stage_name = ""
var event_script := []
var current_event = null
var started = false
var event_index = 0
var choices_made = []
var StageData = null

signal stage_loaded

"""
Base class for stages. A stage script should extend this class. Should be used in conjunction with stage scenes that inherit
the base stage scene. 
"""

# Called when the node enters the scene tree for the first time.
func _ready():
	StageData = get_node("/root/StageData")

func save_stage_progress():
	#StageData.write(persistable)
	pass

func load_stage_state(persistable):
	for i in range(persistable[0]-1):
		event_script.pop_front()

func _process(delta):
	if len(event_script) > 0:
		if current_event == null:
			current_event = event_script.pop_front()
			event_index += 1
			
			match current_event.type:
				Event.EventType.DIALOG:
					current_event.start_event()
					yield(Dialog, "event_complete")
					current_event = null
				Event.EventType.CHOICE:
					current_event.choice_box = ChoiceBox
					current_event.start_event()
					yield(ChoiceBox, "event_complete")
					current_event = null
				Event.EventType.CUSTOM_EVENT:
					current_event.start_event()
					yield(current_event, "event_complete")
					current_event = null

func stage_init():
	for actor in Actors.get_children():
		actor.connect("start_dialog", self, "_on_dialog_start")
	emit_signal("stage_loaded")

func load_setting(setting_name):
	Setting.add_child(load("res://Assets/Scenes/Stages/Settings/" + setting_name + ".tscn").instance())

func _on_ChoiceBox_save_choice(index):
	choices_made.append(index)
	StageData.write_choice(stage_name, choices_made)
	
func _on_dialog_start(name, dialog):
	Dialog.set_actor_name(name)
	Dialog.queueDialog(dialog)

func _on_PauseMenu_create_save(slot_number):
	StageData.save_game(slot_number, stage_name, event_index)

func _on_PauseMenu_load_save(slot_number):
	StageData.load_game(slot_number)

func _on_PauseMenu_delete_save(slot_number):
	StageData.delete_game(slot_number)

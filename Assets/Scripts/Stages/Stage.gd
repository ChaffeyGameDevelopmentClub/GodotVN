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
var last_choice = 0
var started = false
var persistable = [0]
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
	StageData.write(persistable)
	
func start_stage():
	started = true

func load_stage_state(persistable):
	for i in range(persistable[0]-1):
		event_script.pop_front()

func _on_event_start(obj):
	yield(obj, "event_complete")
	current_event = null
	
func branch_event(actor, branches):
	actor.start_dialog(branches[last_choice-1])
	_on_event_start(Dialog)

func _process(delta):
	if len(event_script) > 0:
		if current_event == null:
			current_event = event_script.pop_front()
			persistable[0] += 1
			last_choice = ChoiceBox.get_choice_index()
			if len(current_event) > 2:
				current_event[0].call_func(current_event[2])
				_on_event_start(current_event[1])
			else:
				branch_event(current_event[0], current_event[1])
	
func transition_to_setting():
	pass

func stage_init():
	for actor in Actors.get_children():
		actor.connect("start_dialog", self, "_on_dialog_start")
	emit_signal("stage_loaded")

func load_setting(setting_name):
	Setting.add_child(load("res://Assets/Scenes/Stages/Settings/" + setting_name + ".tscn").instance())

func _on_ChoiceBox_save_choice(index):
	persistable.append(index)
	
func _on_dialog_start(name, dialog):
	Dialog.set_actor_name(name)
	Dialog.queueDialog(dialog)

func _on_PauseMenu_create_save():
	StageData.save_game(1, stage_name, persistable[0])

func _on_PauseMenu_load_save(slot_number):
	StageData.load_game(slot_number)

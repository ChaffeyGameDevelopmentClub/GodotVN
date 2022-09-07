extends Node2D

class_name Stage

onready var MusicPlayer = $MusicPlayer
onready var SFXPlayer = $SFXPlayer
onready var Setting = $Setting #Background
onready var Actors = $Actors
onready var ChoiceBox = $ChoiceBox
var event_script := []
var current_event = null
var last_choice = 0

signal stage_loaded

"""
Base class for stages. A stage script should extend this class. Should be used in conjunction with stage scenes that inherit
the base stage scene. 
"""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_event_start(obj):
	yield(obj, "event_complete")
	current_event = null
	
func branch_event(actor, branches):
	actor.start_dialog(branches[last_choice-1])
	_on_event_start(actor)

func _process(delta):
	if len(event_script) > 0:
		if current_event == null:
			current_event = event_script.pop_front()
			last_choice = ChoiceBox.get_choice_index()
			if len(current_event) > 2:
				current_event[0].call_func(current_event[2])
				_on_event_start(current_event[1])
			else:
				branch_event(current_event[0], current_event[1])
	
	
func transition_to_setting():
	pass

func stage_init():
	emit_signal("stage_loaded")

func load_setting(setting_name):
	Setting.add_child(load("res://Assets/Scenes/Stages/Settings/" + setting_name + ".tscn").instance())

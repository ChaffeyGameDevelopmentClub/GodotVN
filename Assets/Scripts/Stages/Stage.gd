"""
Stage.gd is the base script for all stages. Please inherit both Stage.gd and Stage.tscn to create 
a new stage. You'll need to add the new stage script to the new scene.
"""
extends Node2D

class_name Stage

onready var MusicPlayer = $MusicPlayer
onready var SFXPlayer = $SFXPlayer
onready var Setting = $Setting #Background
onready var Actors = $Actors
onready var ChoiceBox = $ChoiceBox
onready var Dialog = $Dialog
onready var Transition = $Transition
onready var TransitionTween = $Transition/TransitionTween
export var stage_name = ""
var event_script := []
var current_event = null
var started = false
var event_index = 0
var choices_made = []

signal event_complete

#Collection of stage paths used to load a stage by name
const STAGE_PATHS = {
	"TestStageOne": "res://Assets/Scenes/VisualNovel/Stages/StageScenes/TestStageOne.tscn",
	"TestStageTwo": "res://Assets/Scenes/VisualNovel/Stages/StageScenes/TestStageTwo.tscn"
}

signal stage_loaded

"""
Base class for stages. A stage script should extend this class. Should be used in conjunction with stage scenes that inherit
the base stage scene. 
"""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

#Progresses a stage up to a certain point.
func load_stage_state(event):
	event = int(event-1)
	for i in range(event):
		event_script.pop_front().free_event()

#Every iteration, we match the current event (if a current event is loaded) by type
func _process(delta):
	if len(event_script) > 0:
		if current_event == null:
			current_event = event_script.pop_front()
			event_index += 1
			
			match current_event.type:
				Event.EventType.DIALOG:
					current_event.start_event()
					yield(Dialog, "event_complete")
					current_event.free_event()
					current_event = null
				Event.EventType.RESPONSE:
					current_event.start_event()
					yield(Dialog, "event_complete")
					current_event.free_event()
					current_event = null
				Event.EventType.CHOICE:
					current_event.choice_box = ChoiceBox
					current_event.start_event()
					yield(ChoiceBox, "event_complete")
					current_event.free_event()
					current_event = null
				Event.EventType.CONDITIONAL:
					current_event.connect("add_event", self, "on_add_event")
					if current_event.start_event():
						event_index -= 1
					current_event.free_event()
					current_event = null
				Event.EventType.CUSTOM:
					current_event.start_event()
					yield(current_event, "event_complete")
					current_event.free_event()
					current_event = null
				Event.EventType.CHANGESTAGE:
					current_event.connect("change_stage", self, "on_change_stage")
					current_event.start_event()
					current_event.free_event()
					current_event = null

func stage_init():
	for actor in Actors.get_children():
		actor.connect("start_dialog", self, "_on_dialog_start")
	emit_signal("stage_loaded")
	
func on_change_stage(stage_name):
	var current_stage = STAGE_PATHS[stage_name]
	var current_event = 1
	var parent = get_parent()
	parent.current_stage = load(current_stage).instance()
	parent.add_child(parent.current_stage)
	parent.current_stage.load_stage_state(current_event)
	self.queue_free()

#Load up a setting/background
func load_setting(setting_name):
	Setting.add_child(load("res://Assets/Scenes/Stages/Settings/" + setting_name + ".tscn").instance())

#Function that runs on the emission of a choice box's signal for saving a choice
func _on_ChoiceBox_save_choice(index):
	choices_made.append(index)
	StageData.write_choice(stage_name, choices_made)
	
#Function that runs on an actor's signal to start dialog
func _on_dialog_start(name, color, dialog):
	Dialog.set_actor_name(name)
	Dialog.set_color(color)
	Dialog.queueDialog(dialog)

func _on_PauseMenu_create_save(slot_number):
	StageData.save_game(slot_number, stage_name, event_index)

func _on_PauseMenu_load_save(slot_number):
	StageData.load_game(slot_number)
	var current_stage = STAGE_PATHS[StageData.save_state_dict["current_stage"]]
	var current_event = StageData.save_state_dict["current_event"]
	var parent = get_parent()
	parent.current_stage = load(current_stage).instance()
	parent.add_child(parent.current_stage)
	parent.current_stage.load_stage_state(current_event)
	self.queue_free()
	
func set_transition_opacity(opacity):
	Transition.modulate.a = opacity

func event_fade_in(duration):
	TransitionTween.interpolate_property(Transition, "modulate:a", 1, 0, duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	TransitionTween.start()
	yield(TransitionTween, "tween_completed")
	call_deferred("emit_signal", "event_complete")
	
func event_fade_out(duration):
	TransitionTween.interpolate_property(Transition, "modulate:a", 0, 1, duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	TransitionTween.start()
	yield(TransitionTween, "tween_completed")
	call_deferred("emit_signal", "event_complete")
	
func on_add_event(_event):
	event_script.insert(0, _event)
	
func _on_PauseMenu_delete_save(slot_number):
	StageData.delete_game(slot_number)

extends Node2D

class_name Stage

onready var MusicPlayer = $MusicPlayer
onready var SFXPlayer = $SFXPlayer
onready var Setting = $Setting #Background
onready var Actors = $Actors

"""
Base class for stages. A stage script should extend this class. Should be used in conjunction with stage scenes that inherit
the base stage scene. 
"""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func transition_to_setting():
	pass

func load_setting(setting_name):
	Setting.add_child(load("res://Assets/Scenes/Stages/Settings/" + setting_name + ".tscn").instance())

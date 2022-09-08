extends Node2D

signal start_game

onready var bg = $Bg
onready var panel = $Panel
var paused = false
signal create_save
signal load_save

func _input(event):
	if Input.is_action_just_pressed("Pause"):
		paused = not paused
	panel.visible = paused
	bg.visible = paused

func _on_Save_button_down():
	emit_signal("create_save")

func _on_Load_button_down():
	emit_signal("load_save", 1)

func _on_Options_button_down():
	pass # Open options

func _on_Quit_button_down():
	get_tree().quit()

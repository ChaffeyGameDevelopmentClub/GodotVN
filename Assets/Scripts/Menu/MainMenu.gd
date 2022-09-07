extends Node2D

signal start_game

onready var load_menu = null
onready var options_menu = null

func _on_Start_button_down():
	emit_signal("start_game")

func _on_Load_button_down():
	pass # Open load game menu

func _on_Options_button_down():
	pass # Open options

func _on_Exit_button_down():
	get_tree().quit()

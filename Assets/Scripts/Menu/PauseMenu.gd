extends Node2D

signal start_game

onready var bg = $Bg
onready var panel = $Panel
onready var savemenu = $SaveMenu
onready var loadmenu = $LoadMenu
var paused = false
signal create_save
signal load_save
signal delete_save

func _input(event):
	if Input.is_action_just_pressed("Pause"):
		paused = not paused
		panel.visible = paused
		bg.visible = paused

func _on_Save_button_down():
	panel.visible = false
	savemenu.visible = true

func _on_Load_button_down():
	panel.visible = false
	loadmenu.visible = true

func _on_Options_button_down():
	pass # Open options

func _on_Quit_button_down():
	get_tree().quit()

func _on_SaveMenu_create_save(index):
	emit_signal("create_save", index)

func _on_SaveMenu_delete_save(index):
	emit_signal("delete_save", index)

func _on_SaveMenu_menu_closed():
	savemenu.visible = false
	panel.visible = true

func _on_LoadMenu_menu_closed():
	loadmenu.visible = false
	panel.visible = true

func _on_LoadMenu_load_save(index):
	emit_signal("load_save", index)

"""
Main.gd is the script that is responsible for launching the game.
"""
extends Node2D

var main_menu = preload("res://Assets/Scenes/Menu/MainMenu.tscn")
var current_stage = preload("res://Assets/Scenes/VisualNovel/Stages/TestStage.tscn")
var game_start := false #Gameplay has been entered and is running

# Called when the node enters the scene tree for the first time.
func _ready():
	main_menu = main_menu.instance()
	add_child(main_menu)
	main_menu.connect("start_game", self, "_on_game_start")

#On start we remove the main menu from memory and instantiate the game's first scene.
func _on_game_start():
	main_menu.queue_free()
	current_stage = current_stage.instance()
	add_child(current_stage)

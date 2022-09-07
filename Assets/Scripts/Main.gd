extends Node2D

var main_menu = preload("res://Assets/Scenes/Menu/MainMenu.tscn")
var test_stage = preload("res://Assets/Scenes/VisualNovel/Stages/TestStage.tscn")
var game_start := false #Gameplay has been entered and is running

# Called when the node enters the scene tree for the first time.
func _ready():
	main_menu = main_menu.instance()
	add_child(main_menu)
	main_menu.connect("start_game", self, "_on_game_start")

func _on_game_start():
	main_menu.queue_free()
	test_stage = test_stage.instance()
	add_child(test_stage)

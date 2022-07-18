extends Stage


"""
Test stage is a simple demonstration of the current state of visual novel scene scripting.
"""

#First we preload our actors.
var TestActor = preload("res://Assets/Scenes/Stages/Actors/TestActor.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Loading setting")
	load_setting("YoukaiMountainLake")

	var battle = new_battle(null, null)
	yield(get_current_battle(), "game_over")
	battle.queue_free()
	print("OVER")
	


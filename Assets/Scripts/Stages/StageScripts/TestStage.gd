extends Stage


"""
Test stage is a simple demonstration of the current state of visual novel scene scripting.
"""

#First we preload our actors.
var TestActor = preload("res://Assets/Scenes/Stages/Actors/TestActor.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#Now we instance our actors.
	TestActor = TestActor.instance()
	Actors.add_child(TestActor)
	
	#Load the setting/environment.
	Setting.add_child(load("res://Assets/Scenes/Stages/Settings/YoukaiMountainLake.tscn").instance())
	
	#Now we do stage positions.
	TestActor.set_stage_position(Actor.STAGE_POSITION_LEFT)
	yield(TestActor, "finished_action") #Yield to wait until moving is done.
	TestActor.flip_horizontal()
	
	#Now we start scripting!
	TestActor.start_dialog("This is a test scene. It exists to demonstrate an example stage where actors will talk. It will likely be used for cutscene elements.")
	yield(TestActor, "finished_action")
	

